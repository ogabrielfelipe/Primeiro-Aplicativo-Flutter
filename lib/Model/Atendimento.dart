import 'dart:convert';

class Atendimento{
  int? ID;
  String DATA_ABERTURA;
  String NOME_SOLICITANTE;
  String SOLICITACAO;
  String DATA_ENCERRAMENTO;
  String STATUS_ATENDIMENTO;

  Atendimento({this.ID, required this.DATA_ABERTURA, required this.NOME_SOLICITANTE, required this.SOLICITACAO,
      required this.DATA_ENCERRAMENTO, required this.STATUS_ATENDIMENTO});

  factory Atendimento.fromMap(Map<String, dynamic> json) => Atendimento(
      ID: json['ID'],
      DATA_ABERTURA: json['DATA_ABERTURA'],
      NOME_SOLICITANTE: json['NOME_SOLICITANTE'],
      SOLICITACAO: json['SOLICITACAO'],
      DATA_ENCERRAMENTO: json['DATA_ENCERRAMENTO'],
      STATUS_ATENDIMENTO: json['STATUS_ATENDIMENTO'],
  );

  Map<String, Object?> toMap() => {
    "ID": ID,
    "DATA_ABERTURA": DATA_ABERTURA,
    "NOME_SOLICITANTE": NOME_SOLICITANTE,
    "SOLICITACAO": SOLICITACAO,
    "DATA_ENCERRAMENTO": DATA_ENCERRAMENTO,
    "STATUS_ATENDIMENTO": STATUS_ATENDIMENTO,
  };

}