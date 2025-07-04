/// Utility to build Strapi API URLs with filters, populate, and extra query params.
class StrapiUrlBuilder {
  /// Builds a Strapi API URL.
  ///
  /// Example:
  ///   build(
  ///     resource: 'screens',
  ///     filters: {'slug': {'\$eq': 'home'}},
  ///     populate: ['*'],
  ///   )
  ///   => /api/screens?populate=*&filters[slug][$eq]=home
  static String build({
    required String resource,
    Map<String, dynamic>? filters,
    List<String>? populate,
    Map<String, dynamic>? extraParams,
  }) {
    final params = <String, String>{};
    if (filters != null) {
      filters.forEach((key, value) {
        if (value is Map) {
          value.forEach((op, v) {
            params['filters[$key][$op]'] = v.toString();
          });
        } else {
          params['filters[$key]'] = value.toString();
        }
      });
    }
    if (extraParams != null) {
      extraParams.forEach((k, v) => params[k] = v.toString());
    }
    // Build the query string
    final queryParts = <String>[];
    if (populate != null && populate.isNotEmpty) {
      queryParts.add('populate=${populate.join(",")}');
    }
    if (params.isNotEmpty) {
      queryParts.add(Uri(queryParameters: params).query);
    }
    final query = queryParts.isNotEmpty ? '?${queryParts.join("&")}' : '';
    return '/api/$resource$query';
  }
} 