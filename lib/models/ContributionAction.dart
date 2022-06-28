class ContributionAction {
  final int id;
  final String hash_key;
  final String content_hash_str;
  final int contribution_type;
  final String contribution_action_val;
  final String name = "";

  ContributionAction({required this.hash_key,required this.content_hash_str,required this.contribution_type,required this.contribution_action_val,required this.id});

  factory ContributionAction.fromJson(Map<String, dynamic> json) {
    return ContributionAction(
        hash_key: json['hash_key'] == null ? '' : json['hash_key'],
        content_hash_str:  json['content_hash_str'] == null ? '' : json['content_hash_str'],
        contribution_type: json['contribution_type'] == null ? 0 : json['contribution_type'],
        contribution_action_val:  json['contribution_action_val'] == null ? '' : json['contribution_action_val'],
        id: json['_id'] == null ? 0 : json['_id']
    );
  }
}