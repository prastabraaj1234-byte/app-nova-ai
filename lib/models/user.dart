class AppUser {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.subscriptionTier = SubscriptionTier.free,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'subscriptionTier': subscriptionTier.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum SubscriptionTier {
  free,
  plus,
  ultra,
}
