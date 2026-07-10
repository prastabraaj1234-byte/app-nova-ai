import os
import re
import shutil
import tempfile
import unittest
from typing import List, Tuple

# Regex patterns for known API keys, credentials, and password assignments
SECRET_PATTERNS = [
    (r'AIzaSy[A-Za-z0-9_\-]{30,}', "Google API Key"),
    (r'AQ\.Ab8R[A-Za-z0-9_\-]{30,}', "Firebase Credential"),
    (r'(?i)(?:api_key|secret_key|gemini_key|private_key|auth_token)\s*[:=]\s*[\'"](?!(?:your_|placeholder|simulated|default|test|dummy|empty))[A-Za-z0-9_\-\.]{25,}[\'"]', "API/Secret Key Assignment"),
    (r'(?i)(?:password|passwd|pwd)\s*[:=]\s*[\'"](?!(?:your_|placeholder|postgres|secret|admin|root|test|123456|default|empty))[A-Za-z0-9_\-\.\!\@\#\$\%\^\&\*]{8,}[\'"]', "Password Assignment"),
]

class SecretScanner:
    """
    Hardened Working-Tree Secret Scanner.
    
    Documented Behavior:
    - Directories Scanned: All workspace directories starting from root_dir.
    - Extensions Scanned: .dart, .py, .yaml, .yml, .json, .toml, .env, .example, .sh, .ps1, .md, .gradle, .properties, .xml, and Dockerfile.
    - Excluded Directories: .git, build, .dart_tool, .gradle, .idea, node_modules, venv, .env, __pycache__, .pytest_cache, pgdata_local, brain, .gemini.
    - Excluded Files: This scanner script itself, gitleaks reports, and codebase dumps.
    - Maximum File-Size Behavior: Skips any file larger than 5 MB (5 * 1024 * 1024 bytes).
    - Symlink Behavior: Skips symbolic links (os.path.islink).
    - Binary-File Behavior: Skips files with NUL bytes in the first 1024 bytes.
    - Redaction Policy: Never outputs complete secret values; replaces middle characters with '***'.
    """
    def __init__(self, root_dir: str):
        self.root_dir = root_dir
        self.excluded_dirs = {
            'build', '.dart_tool', '.git', '.gradle', '.idea', 'node_modules',
            'venv', '.env', '__pycache__', '.pytest_cache', 'pgdata_local', 'brain', '.gemini'
        }
        self.scanned_extensions = (
            '.dart', '.py', '.yaml', '.yml', '.json', '.toml', '.env', '.example',
            '.sh', '.ps1', '.md', '.gradle', '.properties', '.xml'
        )

    @staticmethod
    def redact_secret(val: str) -> str:
        if len(val) <= 8:
            return val[:2] + "***" + val[-2:]
        return val[:4] + "***" + val[-4:]

    def is_binary_file(self, filepath: str) -> bool:
        try:
            with open(filepath, 'rb') as f:
                chunk = f.read(1024)
                return b'\x00' in chunk
        except Exception:
            return True

    def scan_content(self, content: str, source_name: str) -> List[str]:
        violations = []
        for pattern, label in SECRET_PATTERNS:
            for match in re.finditer(pattern, content):
                val = match.group(0)
                redacted = self.redact_secret(val)
                violations.append(f"[{label}] detected in {source_name}: {redacted}")
        return violations

    def scan_directory(self) -> List[str]:
        violations = []
        for dirpath, dirnames, filenames in os.walk(self.root_dir):
            # Prune excluded directories in-place
            dirnames[:] = [d for d in dirnames if d not in self.excluded_dirs and not d.startswith('.git')]

            for filename in filenames:
                filepath = os.path.join(dirpath, filename)
                
                # Exclude symlinks
                if os.path.islink(filepath):
                    continue
                
                # Check extension or exact Dockerfile name
                if not (filename.lower().endswith(self.scanned_extensions) or filename.lower() == 'dockerfile'):
                    continue

                # Exclude scanner itself, legacy dump files, and historical audit reports
                if filepath == os.path.abspath(__file__) or any(x in filename for x in ('gitleaks_report', 'codebase_dump', '_REPORT.md', 'walkthrough.md', 'task.md')):
                    continue

                # Exclude oversized files (> 5 MB)
                try:
                    if os.path.getsize(filepath) > 5 * 1024 * 1024:
                        continue
                except Exception:
                    continue

                # Exclude binary files
                if self.is_binary_file(filepath):
                    continue

                try:
                    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        rel_path = os.path.relpath(filepath, self.root_dir)
                        violations.extend(self.scan_content(content, rel_path))
                except Exception:
                    pass
        return violations

class TestSecretLeakage(unittest.TestCase):
    def test_no_hardcoded_secrets_in_working_tree(self):
        """Verify entire repository working tree contains 0 secret leaks."""
        root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        scanner = SecretScanner(root_dir)
        violations = scanner.scan_directory()
        self.assertEqual(len(violations), 0, f"Found {len(violations)} secret leakage violations:\n" + "\n".join(violations))

    def test_detects_synthetic_fake_api_key(self):
        """Prove scanner detects synthetic fake Google API keys."""
        scanner = SecretScanner(".")
        fake_content = 'const String apiKey = "AIzaSySyntheticFakeKeyForTesting1234567890";'
        violations = scanner.scan_content(fake_content, "test_file.dart")
        self.assertGreater(len(violations), 0)
        self.assertIn("Google API Key", violations[0])

    def test_detects_synthetic_fake_password_assignment(self):
        """Prove scanner detects synthetic fake password assignments."""
        scanner = SecretScanner(".")
        fake_content = 'password = "SuperSecretProdPassword999!"'
        violations = scanner.scan_content(fake_content, "config.py")
        self.assertGreater(len(violations), 0)
        self.assertIn("Password Assignment", violations[0])

    def test_safe_placeholders_do_not_trigger_false_positives(self):
        """Prove safe placeholders do not trigger false positive detections."""
        scanner = SecretScanner(".")
        safe_content = '''
        GEMINI_API_KEY=your_gemini_api_key_placeholder
        api_key = "placeholder_for_local_dev_12345678"
        password = "postgres"
        DATABASE_URL=postgresql://user:secret@localhost:5432/db
        '''
        violations = scanner.scan_content(safe_content, ".env.example")
        self.assertEqual(len(violations), 0)

    def test_excluded_generated_directories_not_scanned(self):
        """Prove excluded directories like venv/ and __pycache__/ are ignored."""
        with tempfile.TemporaryDirectory() as tmpdir:
            venv_dir = os.path.join(tmpdir, "venv")
            os.makedirs(venv_dir)
            secret_file = os.path.join(venv_dir, "leaked.py")
            with open(secret_file, "w") as f:
                f.write('api_key = "AIzaSyRealLookingSecretKeyThatShouldBeIgnored12345"')
            
            scanner = SecretScanner(tmpdir)
            violations = scanner.scan_directory()
            self.assertEqual(len(violations), 0)

    def test_findings_are_redacted(self):
        """Prove secret scanner redacts detected values and never prints full secret."""
        scanner = SecretScanner(".")
        fake_secret = "AIzaSySecretValueThatMustBeRedacted123456"
        violations = scanner.scan_content(f'key = "{fake_secret}"', "test.py")
        self.assertGreater(len(violations), 0)
        self.assertNotIn(fake_secret, violations[0])
        self.assertIn("***", violations[0])

if __name__ == '__main__':
    unittest.main()
