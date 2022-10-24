// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ArticleData extends DataClass implements Insertable<ArticleData> {
  final String id;
  final String uri;
  final String title;
  final String excerpt;
  final int published;
  final String author;
  final String blog;
  final String android;
  final String ios;
  final int created;
  final int updated;
  final String? memo;
  const ArticleData(
      {required this.id,
      required this.uri,
      required this.title,
      required this.excerpt,
      required this.published,
      required this.author,
      required this.blog,
      required this.android,
      required this.ios,
      required this.created,
      required this.updated,
      this.memo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['uri'] = Variable<String>(uri);
    map['title'] = Variable<String>(title);
    map['excerpt'] = Variable<String>(excerpt);
    map['published'] = Variable<int>(published);
    map['author'] = Variable<String>(author);
    map['blog'] = Variable<String>(blog);
    map['android'] = Variable<String>(android);
    map['ios'] = Variable<String>(ios);
    map['created'] = Variable<int>(created);
    map['updated'] = Variable<int>(updated);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  ArticleCompanion toCompanion(bool nullToAbsent) {
    return ArticleCompanion(
      id: Value(id),
      uri: Value(uri),
      title: Value(title),
      excerpt: Value(excerpt),
      published: Value(published),
      author: Value(author),
      blog: Value(blog),
      android: Value(android),
      ios: Value(ios),
      created: Value(created),
      updated: Value(updated),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory ArticleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleData(
      id: serializer.fromJson<String>(json['id']),
      uri: serializer.fromJson<String>(json['uri']),
      title: serializer.fromJson<String>(json['title']),
      excerpt: serializer.fromJson<String>(json['excerpt']),
      published: serializer.fromJson<int>(json['published']),
      author: serializer.fromJson<String>(json['author']),
      blog: serializer.fromJson<String>(json['blog']),
      android: serializer.fromJson<String>(json['android']),
      ios: serializer.fromJson<String>(json['ios']),
      created: serializer.fromJson<int>(json['created']),
      updated: serializer.fromJson<int>(json['updated']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'uri': serializer.toJson<String>(uri),
      'title': serializer.toJson<String>(title),
      'excerpt': serializer.toJson<String>(excerpt),
      'published': serializer.toJson<int>(published),
      'author': serializer.toJson<String>(author),
      'blog': serializer.toJson<String>(blog),
      'android': serializer.toJson<String>(android),
      'ios': serializer.toJson<String>(ios),
      'created': serializer.toJson<int>(created),
      'updated': serializer.toJson<int>(updated),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  ArticleData copyWith(
          {String? id,
          String? uri,
          String? title,
          String? excerpt,
          int? published,
          String? author,
          String? blog,
          String? android,
          String? ios,
          int? created,
          int? updated,
          Value<String?> memo = const Value.absent()}) =>
      ArticleData(
        id: id ?? this.id,
        uri: uri ?? this.uri,
        title: title ?? this.title,
        excerpt: excerpt ?? this.excerpt,
        published: published ?? this.published,
        author: author ?? this.author,
        blog: blog ?? this.blog,
        android: android ?? this.android,
        ios: ios ?? this.ios,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        memo: memo.present ? memo.value : this.memo,
      );
  @override
  String toString() {
    return (StringBuffer('ArticleData(')
          ..write('id: $id, ')
          ..write('uri: $uri, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('published: $published, ')
          ..write('author: $author, ')
          ..write('blog: $blog, ')
          ..write('android: $android, ')
          ..write('ios: $ios, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uri, title, excerpt, published, author,
      blog, android, ios, created, updated, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleData &&
          other.id == this.id &&
          other.uri == this.uri &&
          other.title == this.title &&
          other.excerpt == this.excerpt &&
          other.published == this.published &&
          other.author == this.author &&
          other.blog == this.blog &&
          other.android == this.android &&
          other.ios == this.ios &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.memo == this.memo);
}

class ArticleCompanion extends UpdateCompanion<ArticleData> {
  final Value<String> id;
  final Value<String> uri;
  final Value<String> title;
  final Value<String> excerpt;
  final Value<int> published;
  final Value<String> author;
  final Value<String> blog;
  final Value<String> android;
  final Value<String> ios;
  final Value<int> created;
  final Value<int> updated;
  final Value<String?> memo;
  const ArticleCompanion({
    this.id = const Value.absent(),
    this.uri = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.published = const Value.absent(),
    this.author = const Value.absent(),
    this.blog = const Value.absent(),
    this.android = const Value.absent(),
    this.ios = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.memo = const Value.absent(),
  });
  ArticleCompanion.insert({
    required String id,
    required String uri,
    required String title,
    required String excerpt,
    required int published,
    required String author,
    required String blog,
    required String android,
    required String ios,
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.memo = const Value.absent(),
  })  : id = Value(id),
        uri = Value(uri),
        title = Value(title),
        excerpt = Value(excerpt),
        published = Value(published),
        author = Value(author),
        blog = Value(blog),
        android = Value(android),
        ios = Value(ios);
  static Insertable<ArticleData> custom({
    Expression<String>? id,
    Expression<String>? uri,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<int>? published,
    Expression<String>? author,
    Expression<String>? blog,
    Expression<String>? android,
    Expression<String>? ios,
    Expression<int>? created,
    Expression<int>? updated,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uri != null) 'uri': uri,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (published != null) 'published': published,
      if (author != null) 'author': author,
      if (blog != null) 'blog': blog,
      if (android != null) 'android': android,
      if (ios != null) 'ios': ios,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (memo != null) 'memo': memo,
    });
  }

  ArticleCompanion copyWith(
      {Value<String>? id,
      Value<String>? uri,
      Value<String>? title,
      Value<String>? excerpt,
      Value<int>? published,
      Value<String>? author,
      Value<String>? blog,
      Value<String>? android,
      Value<String>? ios,
      Value<int>? created,
      Value<int>? updated,
      Value<String?>? memo}) {
    return ArticleCompanion(
      id: id ?? this.id,
      uri: uri ?? this.uri,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      published: published ?? this.published,
      author: author ?? this.author,
      blog: blog ?? this.blog,
      android: android ?? this.android,
      ios: ios ?? this.ios,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      memo: memo ?? this.memo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (published.present) {
      map['published'] = Variable<int>(published.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (blog.present) {
      map['blog'] = Variable<String>(blog.value);
    }
    if (android.present) {
      map['android'] = Variable<String>(android.value);
    }
    if (ios.present) {
      map['ios'] = Variable<String>(ios.value);
    }
    if (created.present) {
      map['created'] = Variable<int>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<int>(updated.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticleCompanion(')
          ..write('id: $id, ')
          ..write('uri: $uri, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('published: $published, ')
          ..write('author: $author, ')
          ..write('blog: $blog, ')
          ..write('android: $android, ')
          ..write('ios: $ios, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

class Article extends Table with TableInfo<Article, ArticleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Article(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  final VerificationMeta _uriMeta = const VerificationMeta('uri');
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _excerptMeta = const VerificationMeta('excerpt');
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _publishedMeta = const VerificationMeta('published');
  late final GeneratedColumn<int> published = GeneratedColumn<int>(
      'published', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _authorMeta = const VerificationMeta('author');
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _blogMeta = const VerificationMeta('blog');
  late final GeneratedColumn<String> blog = GeneratedColumn<String>(
      'blog', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _androidMeta = const VerificationMeta('android');
  late final GeneratedColumn<String> android = GeneratedColumn<String>(
      'android', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _iosMeta = const VerificationMeta('ios');
  late final GeneratedColumn<String> ios = GeneratedColumn<String>(
      'ios', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  late final GeneratedColumn<int> created = GeneratedColumn<int>(
      'created', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression<int>('strftime(\'%s\', \'now\')'));
  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  late final GeneratedColumn<int> updated = GeneratedColumn<int>(
      'updated', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK(updated >= created)',
      defaultValue: const CustomExpression<int>('strftime(\'%s\', \'now\')'));
  final VerificationMeta _memoMeta = const VerificationMeta('memo');
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uri,
        title,
        excerpt,
        published,
        author,
        blog,
        android,
        ios,
        created,
        updated,
        memo
      ];
  @override
  String get aliasedName => _alias ?? 'article';
  @override
  String get actualTableName => 'article';
  @override
  VerificationContext validateIntegrity(Insertable<ArticleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('excerpt')) {
      context.handle(_excerptMeta,
          excerpt.isAcceptableOrUnknown(data['excerpt']!, _excerptMeta));
    } else if (isInserting) {
      context.missing(_excerptMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('blog')) {
      context.handle(
          _blogMeta, blog.isAcceptableOrUnknown(data['blog']!, _blogMeta));
    } else if (isInserting) {
      context.missing(_blogMeta);
    }
    if (data.containsKey('android')) {
      context.handle(_androidMeta,
          android.isAcceptableOrUnknown(data['android']!, _androidMeta));
    } else if (isInserting) {
      context.missing(_androidMeta);
    }
    if (data.containsKey('ios')) {
      context.handle(
          _iosMeta, ios.isAcceptableOrUnknown(data['ios']!, _iosMeta));
    } else if (isInserting) {
      context.missing(_iosMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArticleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      uri: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}uri'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt'])!,
      published: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}published'])!,
      author: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      blog: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}blog'])!,
      android: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}android'])!,
      ios: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}ios'])!,
      created: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}created'])!,
      updated: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}updated'])!,
      memo: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
    );
  }

  @override
  Article createAlias(String alias) {
    return Article(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class KvData extends DataClass implements Insertable<KvData> {
  final String k;
  final Uint8List v;
  final int created;
  final int updated;
  final String? memo;
  const KvData(
      {required this.k,
      required this.v,
      required this.created,
      required this.updated,
      this.memo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['k'] = Variable<String>(k);
    map['v'] = Variable<Uint8List>(v);
    map['created'] = Variable<int>(created);
    map['updated'] = Variable<int>(updated);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  KvCompanion toCompanion(bool nullToAbsent) {
    return KvCompanion(
      k: Value(k),
      v: Value(v),
      created: Value(created),
      updated: Value(updated),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory KvData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvData(
      k: serializer.fromJson<String>(json['k']),
      v: serializer.fromJson<Uint8List>(json['v']),
      created: serializer.fromJson<int>(json['created']),
      updated: serializer.fromJson<int>(json['updated']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'k': serializer.toJson<String>(k),
      'v': serializer.toJson<Uint8List>(v),
      'created': serializer.toJson<int>(created),
      'updated': serializer.toJson<int>(updated),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  KvData copyWith(
          {String? k,
          Uint8List? v,
          int? created,
          int? updated,
          Value<String?> memo = const Value.absent()}) =>
      KvData(
        k: k ?? this.k,
        v: v ?? this.v,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        memo: memo.present ? memo.value : this.memo,
      );
  @override
  String toString() {
    return (StringBuffer('KvData(')
          ..write('k: $k, ')
          ..write('v: $v, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(k, $driftBlobEquality.hash(v), created, updated, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvData &&
          other.k == this.k &&
          $driftBlobEquality.equals(other.v, this.v) &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.memo == this.memo);
}

class KvCompanion extends UpdateCompanion<KvData> {
  final Value<String> k;
  final Value<Uint8List> v;
  final Value<int> created;
  final Value<int> updated;
  final Value<String?> memo;
  const KvCompanion({
    this.k = const Value.absent(),
    this.v = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.memo = const Value.absent(),
  });
  KvCompanion.insert({
    required String k,
    required Uint8List v,
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.memo = const Value.absent(),
  })  : k = Value(k),
        v = Value(v);
  static Insertable<KvData> custom({
    Expression<String>? k,
    Expression<Uint8List>? v,
    Expression<int>? created,
    Expression<int>? updated,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (k != null) 'k': k,
      if (v != null) 'v': v,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (memo != null) 'memo': memo,
    });
  }

  KvCompanion copyWith(
      {Value<String>? k,
      Value<Uint8List>? v,
      Value<int>? created,
      Value<int>? updated,
      Value<String?>? memo}) {
    return KvCompanion(
      k: k ?? this.k,
      v: v ?? this.v,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      memo: memo ?? this.memo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (k.present) {
      map['k'] = Variable<String>(k.value);
    }
    if (v.present) {
      map['v'] = Variable<Uint8List>(v.value);
    }
    if (created.present) {
      map['created'] = Variable<int>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<int>(updated.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KvCompanion(')
          ..write('k: $k, ')
          ..write('v: $v, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

class Kv extends Table with TableInfo<Kv, KvData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Kv(this.attachedDatabase, [this._alias]);
  final VerificationMeta _kMeta = const VerificationMeta('k');
  late final GeneratedColumn<String> k = GeneratedColumn<String>(
      'k', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  final VerificationMeta _vMeta = const VerificationMeta('v');
  late final GeneratedColumn<Uint8List> v = GeneratedColumn<Uint8List>(
      'v', aliasedName, false,
      type: DriftSqlType.blob,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  late final GeneratedColumn<int> created = GeneratedColumn<int>(
      'created', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression<int>('strftime(\'%s\', \'now\')'));
  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  late final GeneratedColumn<int> updated = GeneratedColumn<int>(
      'updated', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK(updated >= created)',
      defaultValue: const CustomExpression<int>('strftime(\'%s\', \'now\')'));
  final VerificationMeta _memoMeta = const VerificationMeta('memo');
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [k, v, created, updated, memo];
  @override
  String get aliasedName => _alias ?? 'kv';
  @override
  String get actualTableName => 'kv';
  @override
  VerificationContext validateIntegrity(Insertable<KvData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    } else if (isInserting) {
      context.missing(_kMeta);
    }
    if (data.containsKey('v')) {
      context.handle(_vMeta, v.isAcceptableOrUnknown(data['v']!, _vMeta));
    } else if (isInserting) {
      context.missing(_vMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {k};
  @override
  KvData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvData(
      k: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}k'])!,
      v: attachedDatabase.options.types
          .read(DriftSqlType.blob, data['${effectivePrefix}v'])!,
      created: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}created'])!,
      updated: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}updated'])!,
      memo: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
    );
  }

  @override
  Kv createAlias(String alias) {
    return Kv(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final Article article = Article(this);
  late final Index articlePublishedIdx = Index('article_published_idx',
      'CREATE INDEX IF NOT EXISTS article_published_idx ON article (published)');
  late final Index articleUriIdx = Index('article_uri_idx',
      'CREATE INDEX IF NOT EXISTS article_uri_idx ON article (uri)');
  late final Index articleUpdatedIdx = Index('article_updated_idx',
      'CREATE INDEX IF NOT EXISTS article_updated_idx ON article (updated)');
  late final Index articleCreatedIdx = Index('article_created_idx',
      'CREATE INDEX IF NOT EXISTS article_created_idx ON article (created)');
  late final Kv kv = Kv(this);
  late final Index kvCreatedIdx = Index('kv_created_idx',
      'CREATE INDEX IF NOT EXISTS kv_created_idx ON kv (created)');
  late final Index kvUpdatedIdx = Index('kv_updated_idx',
      'CREATE INDEX IF NOT EXISTS kv_updated_idx ON kv (updated)');
  Selectable<KvData> getAllKV() {
    return customSelect('SELECT * FROM kv', variables: [], readsFrom: {
      kv,
    }).asyncMap(kv.mapFromRow);
  }

  Selectable<Uint8List> getByKey(String key) {
    return customSelect('SELECT v FROM kv WHERE k = ?1 LIMIT 1', variables: [
      Variable<String>(key)
    ], readsFrom: {
      kv,
    }).map((QueryRow row) => row.read<Uint8List>('v'));
  }

  Selectable<GetByKeysResult> getByKeys(List<String> var1) {
    var $arrayStartIndex = 1;
    final expandedvar1 = $expandVar($arrayStartIndex, var1.length);
    $arrayStartIndex += var1.length;
    return customSelect('SELECT k, v FROM kv WHERE k IN ($expandedvar1)',
        variables: [
          for (var $ in var1) Variable<String>($)
        ],
        readsFrom: {
          kv,
        }).map((QueryRow row) {
      return GetByKeysResult(
        k: row.read<String>('k'),
        v: row.read<Uint8List>('v'),
      );
    });
  }

  Future<int> deleteByKey(String key) {
    return customUpdate(
      'DELETE FROM kv WHERE k = ?1',
      variables: [Variable<String>(key)],
      updates: {kv},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> deleteByKeys(List<String> var1) {
    var $arrayStartIndex = 1;
    final expandedvar1 = $expandVar($arrayStartIndex, var1.length);
    $arrayStartIndex += var1.length;
    return customUpdate(
      'DELETE FROM kv WHERE k IN ($expandedvar1)',
      variables: [for (var $ in var1) Variable<String>($)],
      updates: {kv},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> upsertKV(String key, Uint8List value, String? memo) {
    return customInsert(
      'INSERT INTO kv (k, v, memo) VALUES (?1, ?2, ?3) ON CONFLICT (k) DO UPDATE SET k = excluded.k, v = excluded.v, updated = strftime(\'%s\', \'now\'), memo = excluded.memo WHERE excluded.k > kv.k',
      variables: [
        Variable<String>(key),
        Variable<Uint8List>(value),
        Variable<String>(memo)
      ],
      updates: {kv},
    );
  }

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        article,
        articlePublishedIdx,
        articleUriIdx,
        articleUpdatedIdx,
        articleCreatedIdx,
        kv,
        kvCreatedIdx,
        kvUpdatedIdx
      ];
}

class GetByKeysResult {
  final String k;
  final Uint8List v;
  GetByKeysResult({
    required this.k,
    required this.v,
  });
}
