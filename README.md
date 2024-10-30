# Agenda de Contatos - Flutter

Este é um app de agenda de contatos desenvolvido em Flutter, permitindo adicionar, editar, listar e remover contatos (nome, telefone e e-mail).<br />

Funcionalidades<br />
Listar, adicionar, editar e remover contatos.<br />
Persistência de dados.<br />
Paleta de cores inspirada na Binance: amarelo (#F0B90B), cinza escuro (#12161C), e cinza claro (#848E9C).<br />


Estrutura do Projeto<br />
lib/<br />
├── models/contato.dart             # Modelo de contato<br />
├── screens/contact_list_screen.dart  # Tela de listagem<br />
├── screens/contact_form_screen.dart  # Tela de formulário<br />
└── main.dart                       # Arquivo principal<br />

Feito dia 30/10 (ATIVIDADE NÃO ENTREGUE NO PRAZO, CONSIDERE SE PUDER)
  Implementar persistencia em banco de dados na atividade da agenda

Feito dia 30/10 (ATIVIDADE NÃO ENTREGUE NO PRAZO, CONSIDERE SE PUDER)
  Implementar tela de login
     - Criar tabela de login no banco
     - Na tela ter opção de cadastrar
     - Ao Logar guardar nome de usuario como token no sharedPreferences
  Ao entrar no app verificar o token guardado no sharedPreferences
     - Caso possua token entrar para tela de listagem
