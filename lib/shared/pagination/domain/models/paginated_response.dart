const int PER_PAGE_LIMIT = 20;

class PaginatedResponse<T> {
  final int total;

  final int skip;

  final int limit ;

  final List<T> data;

  PaginatedResponse(this.limit,
      {required this.total, required this.skip, required this.data});

  factory PaginatedResponse.fromJson(dynamic json, List<T> data, {String? total, String? skip, String? limit,
          Function(dynamic json)? fixture}) =>
      PaginatedResponse(
        total: json[total ?? 'total'] ?? 0,
        skip: json[skip ?? 'skip'] ?? 0,
        json[limit ?? 'limit'] ?? PER_PAGE_LIMIT,
        data: data,
      );
  @override
  String toString() {
    return 'PaginatedResponse(total:$total, skip:$skip, data:${data.length})';
  }
}
