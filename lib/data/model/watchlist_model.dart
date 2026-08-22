import 'package:equatable/equatable.dart';

class WatchlistModel extends Equatable {
  final String id;
  final String name;
  final List<String> stockSymbols;

  const WatchlistModel({
    required this.id,
    required this.name,
    required this.stockSymbols,
  });

  WatchlistModel copyWith({
    String? name,
    List<String>? stockSymbols,
  }) {
    return WatchlistModel(
      id: id,
      name: name ?? this.name,
      stockSymbols: stockSymbols ?? this.stockSymbols,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'stockSymbols': stockSymbols,
  };

  factory WatchlistModel.fromJson(Map<String, dynamic> json) => WatchlistModel(
    id: json['id'] as String,
    name: json['name'] as String,
    stockSymbols: List<String>.from(json['stockSymbols'] as List),
  );

  @override
  List<Object?> get props => [id, name, stockSymbols];
}