class PaginationInfo {
  final int total;
  final int numOfPages;
  final int currentPage;
  final int pageSize;

  PaginationInfo({
    required this.total,
    required this.numOfPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] ?? 0,
      numOfPages: json['numOfPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'numOfPages': numOfPages,
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }
}
