import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';

class PaginaUbs {
  final List<UbsEntity> itens;
  final String? proximoCursor; // valor de 'nome_normalizado' do último item — não é um tipo do Firestore
  final bool temMais;

  const PaginaUbs({
  required this.itens, 
  this.proximoCursor, 
  required this.temMais});
}