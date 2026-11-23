# Pérola do Porto

Sistema web de gestão de pousada desenvolvido com Java, Servlets, JSP e MySQL. O projeto separa as telas JSP, os controladores HTTP, os DAOs de acesso a dados e o script de criação do banco.

## Visão geral do front-end

### Entrada, login e navegação

- `PerolaDoPorto/web/index.jsp` é a entrada do sistema. Sem sessão autenticada, apresenta a página pública da pousada; com sessão, mostra o painel da equipe e os módulos disponíveis ao perfil.
- `PerolaDoPorto/web/form_login.jsp` contém o formulário de acesso da equipe.
- `PerolaDoPorto/web/banner.jsp` fornece o cabeçalho visual compartilhado.
- `PerolaDoPorto/web/menu.jsp` mostra o nome e perfil da pessoa autenticada, os itens de navegação permitidos e a opção de sair.
- `PerolaDoPorto/web/acesso_negado.jsp` apresenta a resposta de acesso proibido.

As páginas compartilham `PerolaDoPorto/web/css/estilo.css`, que define a identidade visual, painéis, formulários, tabelas, botões e layouts responsivos. `PerolaDoPorto/web/js/app-dialog.js` contém as caixas de mensagem e confirmação usadas em ações como desativar ou desvincular registros. O banner da pousada fica em `PerolaDoPorto/web/imagens/banner.png`.

### Módulos e telas

| Módulo | Listagem | Formulário e operações |
|---|---|---|
| Clientes | `listar_cliente.jsp` | `form_cliente.jsp` para cadastro e edição |
| Quartos | `listar_quarto.jsp` | `form_quarto.jsp` para cadastro e edição |
| Serviços | `listar_servico.jsp` | `form_servico.jsp` para cadastro e edição |
| Usuários | `listar_usuario.jsp` | `form_usuario.jsp` para cadastro e edição |
| Diárias | `listar_diaria.jsp` | `form_diaria.jsp` inicia a hospedagem e seleciona quartos; `form_finalizar_diaria.jsp` registra ou edita os dados da diária |
| Quartos da diária | — | `form_diaria_quarto.jsp` associa quartos e apresenta check-in, check-out e valor |
| Serviços da diária | — | `form_diaria_quarto_servico.jsp` permite adicionar itens ao carrinho do quarto e lançar a seleção na conta e nas pendências |
| Pendências | `listar_pendencias.jsp` | `form_pendencias.jsp` para registro e edição |
| Perfis | `listar_perfil.jsp` | `form_perfil.jsp` para gerenciar perfis |
| Menus e permissões | `listar_menu.jsp` | `form_menu.jsp` gerencia rotas; `form_menu_perfil.jsp` associa rotas a perfis |

As operações são enviadas aos Servlets mapeados em `PerolaDoPorto/web/WEB-INF/web.xml`. Os controladores processam as ações e usam os DAOs para consultar ou persistir dados. A autorização é feita no servidor pelo filtro `AutorizacaoFilter`, não apenas escondendo botões: a rota e a ação precisam estar associadas ao perfil.

## Perfis iniciais

O script cadastra perfis e permissões, mas **não cria contas de usuário**.

- **Auxiliar de limpeza:** consulta e altera quartos; não acessa pendências.
- **Atendente:** acessa atendimento a clientes, consulta de quartos, serviços, equipe, diárias, associações de serviços e pendências conforme as permissões cadastradas.
- **Gerente:** gerencia as operações da pousada, usuários e perfis, incluindo diárias e seus quartos/serviços.
- **Administrador:** recebe as permissões gerais, inclusive gerenciamento de menus e associação de permissões a perfis.

Os menus visíveis usam `menu.exibir = 1`. As entradas com `exibir = 0` representam permissões de ação e não aparecem como links de navegação.

## Banco de dados

O banco usado pela aplicação é **`perolatcc_novo`**. O arquivo `PerolaDoPorto/perolatcc.sql` cria o banco caso ainda não exista, seleciona-o e cria as tabelas com `IF NOT EXISTS`, chaves e índices. As chaves estrangeiras são verificadas antes de serem adicionadas e os registros iniciais usam verificações para evitar duplicação ao executar novamente o script. `IF NOT EXISTS` não migra a estrutura de uma tabela antiga; o banco novo separa esta instalação do schema anterior `perolatcc`.

### Tabelas

| Tabela | Finalidade |
|---|---|
| `cliente` | Hóspedes e demais clientes, com documento, dados cadastrais, tipo e situação |
| `quarto` | Número, tipo, descrição, valor e situação dos quartos |
| `servico` | Nome, valor e situação dos serviços oferecidos |
| `usuario` | Contas da equipe e o perfil associado |
| `perfil` | Perfis e situação de cada perfil |
| `menu` | Módulos e ações do sistema; `link` identifica a rota e a ação |
| `menu_perfil` | Associação entre permissões de menu e perfis |
| `diaria` | Hospedagem, hóspede, responsável, datas, valores e situação de pagamento |
| `diaria_quarto` | Associação de quartos à diária, com valor e datas de entrada/saída |
| `diaria_quarto_servico` | Serviços associados ao quarto de uma diária e valor contratado |
| `pendencias` | Pendências e sua associação opcional ao serviço de um quarto em uma diária |

### Relações principais

- `usuario.perfil_idPerfil` referencia `perfil`.
- `menu_perfil` relaciona `menu` e `perfil`, com chave composta.
- `diaria` referencia o usuário responsável e o cliente; pode referenciar uma pendência.
- `diaria_quarto` relaciona `diaria` e `quarto`, com chave composta.
- `diaria_quarto_servico` relaciona uma associação diária/quarto a um `servico`, também com chave composta.
- `pendencias` pode referenciar a combinação diária/quarto/serviço correspondente.

Ao confirmar o carrinho de serviços, a aplicação associa cada serviço ao quarto da diária e cria uma pendência ativa pelo valor do serviço. A tela de pendências apresenta o hóspede, a diária, o número do quarto e o serviço. O acesso a essa tela e às suas ações é atribuído somente a atendentes, gerentes e administradores.

Os identificadores principais são incrementais. As associações diárias/quarto, diária/quarto/serviço e menu/perfil usam chaves compostas para evitar vínculos repetidos.

## Preparar uma conexão e instalar o banco

Uma **conexão salva no MySQL Workbench** é configuração da ferramenta; o script SQL não cria essa conexão. Para preparar uma instalação nova:

1. No Workbench, crie uma conexão para o servidor MySQL local, usando o host, a porta e as credenciais configuradas na sua instalação.
2. Abra `PerolaDoPorto/perolatcc.sql`.
3. Execute o script inteiro, não somente a linha selecionada ou a instrução sob o cursor. Ele cria e seleciona `perolatcc_novo`; o banco anterior `perolatcc` não é apagado.
4. Configure a aplicação com o mesmo servidor, banco, usuário e senha. O padrão em `PerolaDoPorto/src/java/dao/DataBaseDAO.java` aponta para `localhost:3306/perolatcc_novo`.
5. Se necessário, configure `PEROLA_DB_URL`, `PEROLA_DB_USER` e `PEROLA_DB_PASSWORD`. Propriedades Java `perola.db.url`, `perola.db.user` e `perola.db.password` também podem substituir os padrões.

O projeto precisa do driver JDBC do MySQL no classpath do servidor. O script cria os quatro perfis e suas permissões, mas não cria usuário administrador; será necessário cadastrar uma conta associada ao perfil apropriado antes do primeiro login.
