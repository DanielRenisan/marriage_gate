class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://mgate.runasp.net/api';

  // Endpoints
  static const String register = '/Auth/register';
  static const String login = '/Auth/login';

  // Client token API endpoint
  static const String clientTokenEndpoint =
      '/Client/client-token?name=member&secretKey=member123';

  // Client token - In a real app, this should be stored securely and refreshed as needed
  static const String clientToken =
      'eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJDbGllbnRJZCI6IjAxOTVmYWJmLTkwYWEtN2IxZC1hYTY5LWNjOTkwMGE3Y2VlYyIsIkNsaWVudE5hbWUiOiJtZW1iZXIiLCJDbGllbnRUeXBlIjoiV2ViIiwiVXNlclR5cGUiOiJNZW1iZXIiLCJUb2tlblR5cGUiOiJDbGllbnRUb2tlbiIsIm5iZiI6MTc1MzQxNDU0NCwiZXhwIjoxNzg0OTUwNTQ0LCJpc3MiOiJtYXRyaW1vbnkiLCJhdWQiOiJtYXRyaW1vbnkifQ.b7BqEf9-QA5PtYx5Sgk20CgRxhlm_nrWcHVNuPcnpvM';

  // Login types
  static const int loginTypeEmail = 1;
  static const int loginTypeMobile = 2;
  static const int loginTypeGoogle = 3;
  static const int loginTypeFacebook = 4;
}
