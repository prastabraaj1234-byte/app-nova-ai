import os
import re
import unittest

# Regex patterns for known API keys and secrets
SECRET_PATTERNS = [
    r'AIzaSy[A-Za-z0-9_\-]{30,}',
    r'AQ\.Ab8R[A-Za-z0-9_\-]{30,}',
    r'(?i)(api_key|secret_key|gemini_key)\s*[:=]\s*[\'"][A-Za-z0-9_\-\.]{25,}[\'"]',
]

class TestSecretLeakage(unittest.TestCase):
    def test_no_hardcoded_secrets_in_working_tree(self):
        root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        violations = []

        for dirpath, dirnames, filenames in os.walk(root_dir):
            # Exclude build, cache, and git directories
            dirnames[:] = [d for d in dirnames if d not in ('build', '.dart_tool', '.git', '.gradle', '.idea', 'node_modules')]
            
            for filename in filenames:
                if filename.endswith(('.dart', '.yaml', '.yml', '.json', '.env', '.py')):
                    filepath = os.path.join(dirpath, filename)
                    # Skip this test file itself and gitleaks reports
                    if filepath == os.path.abspath(__file__) or 'gitleaks_report' in filename or 'codebase_dump' in filename:
                        continue
                    
                    try:
                        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                            for pattern in SECRET_PATTERNS:
                                matches = re.findall(pattern, content)
                                if matches:
                                    violations.append(f"Secret detected in {os.path.relpath(filepath, root_dir)}: pattern {pattern}")
                    except Exception as e:
                        pass

        self.assertEqual(len(violations), 0, f"Found {len(violations)} secret leakage violations:\n" + "\n".join(violations))

if __name__ == '__main__':
    unittest.main()
