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
    // Build params in a deterministic order: filters -> populate -> extraParams
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

    // Add populate after filters so ordering is deterministic. Use comma-joined
    // value and let Uri.encode the characters (e.g. '*' -> %2A, ',' -> %2C).
    if (populate != null && populate.isNotEmpty) {
      params['populate'] = populate.join(',');
    }

    if (extraParams != null) {
      extraParams.forEach((k, v) => params[k] = v.toString());
    }

    final query = params.isNotEmpty ? '?${Uri(queryParameters: params).query}' : '';
    return '/api/$resource$query';
  }
} 