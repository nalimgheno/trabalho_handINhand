class Fundraiser {
    final String name;
    final String phone;
    final double amount;
    final String purpose;
    final String? description;
    final List<dynamic> images;
    final double goal;
    bool isClosed; // Novo atributo para indicar se a vaquinha está encerrada

    Fundraiser({
      required this.name,
      required this.phone,
      required this.amount,
      required this.purpose,
      required this.description,
      required this.images,
      required this.goal, // Adicionado o parâmetro no construtor
      this.isClosed = false, // Inicializa como falso por padrão
    });
  }
