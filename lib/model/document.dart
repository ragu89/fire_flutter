class Document extends Comparable {
  final String title;
  final String subtitle;
  Document({
    this.title,
    this.subtitle,
  });

  // Add the document ID to the post model when serialising.
  static Document fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    return Document(
      title: map['title'],
      subtitle: map['subtitle'],
    );
  }

  @override
  int compareTo(other) {
    if (other is Document) {
      return other.title.compareTo(title);
    } else {
      return 0;
    }
  }
}
