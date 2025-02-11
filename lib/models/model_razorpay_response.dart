class ModelRazorPayResponse {
  String? id = '';
  String? entity = '';
  int? amount = 0;
  int? amountPaid = 0;
  int? amountDue = 0;
  String? currency = '';
  String? receipt = '';
  String? offerId = '';
  String? status = '';
  int? attempts = 0;
  List<dynamic>? notes;
  int? createdAt = 0;

  ModelRazorPayResponse({
    this.id = '',
    this.entity = '',
    this.amount = 0,
    this.amountPaid = 0,
    this.amountDue = 0,
    this.currency = '',
    this.receipt = '',
    this.offerId = '',
    this.status = '',
    this.attempts = 0,
    this.notes,
    this.createdAt = 0,
  });

  ModelRazorPayResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    entity = json["entity"].toString();
    amount = json["amount"];
    amountPaid = json["amount_paid"];
    amountDue = json["amount_due"];
    currency = json["currency"].toString();
    receipt = json["receipt"].toString();
    offerId = json["offer_id"].toString();
    status = json["status"].toString();
    attempts = json["attempts"];
    notes = json["notes"] == null ? [] : List<dynamic>.from(json["notes"]);
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["entity"] = entity;
    data["amount"] = amount;
    data["amount_paid"] = amountPaid;
    data["amount_due"] = amountDue;
    data["currency"] = currency;
    data["receipt"] = receipt;
    data["offer_id"] = offerId;
    data["status"] = status;
    data["attempts"] = attempts;
    if (notes != null) {
      data["notes"] = notes;
    }
    data["created_at"] = createdAt;
    return data;
  }
}
