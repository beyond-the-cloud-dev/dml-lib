global interface Error {
    String message();
    System.StatusCode statusCode();
    List<String> fields();
}
