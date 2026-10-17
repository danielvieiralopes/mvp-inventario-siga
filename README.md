# MVP Inventário Físico x Siga

Aplicação local para controlar inventário físico, comparar o estoque com o Siga, acompanhar fechamentos, registrar vendas diárias e gerar listas de compra. O MVP roda diretamente no navegador e está concentrado no arquivo `index.html`.

## Funcionalidades

- Importação de planilhas XLSX e XLS com as abas `BASE`, `INVENTARIO` e `COMPRA`.
- Levantamento físico por item, com edição de quantidade, descrição, valor, quantidade mínima e status do item.
- Inclusão de novos itens e desativação de itens que não devem participar das compras.
- Lista de compra operacional com filtros, quantidade levantada, quantidade mínima, valor unitário e total.
- Comparação com o JSON exportado do Siga e identificação de baixas, divergências e itens não encontrados.
- Painel financeiro com dinheiro físico, dinheiro no Siga, diferença de caixa e fundo bíblico atual.
- Aba **Estoque atual** com saldo no Siga, físico contado, baixa pendente, saldo projetado e valores monetários.
- Histórico independente de fechamentos, preservado mesmo após iniciar uma nova contagem.
- Lista de compra gerada a partir do estoque histórico consultado, sem alterar os dados até o usuário confirmar o fluxo.
- Registro de vendas diárias usando o estoque atual como saldo inicial.
- Consolidação das vendas ao encerrar o dia, com atualização de quantidades, valores e novo snapshot histórico.
- Fechamentos mensais com restauração do estado completo.
- Histórico de listas de compra e históricos de JSON do Siga.
- Exportação de relatório completo em XLSX, de cada fechamento salvo em XLSX e de listas em CSV.
- Backup completo em JSON e restauração posterior.
- Salvamento automático no navegador e restauração após atualizar a página.

## Como usar

1. Abra o arquivo `index.html` no navegador.
2. Clique em **Abrir planilha** e selecione a planilha atual.
3. Na aba **Levantamento físico**, informe ou ajuste as quantidades contadas.
4. Na aba **Comparar com Siga**, cole o JSON exportado e clique em **Comparar com inventário físico**.
5. Consulte a aba **Estoque atual** para visualizar saldos, valores e baixas pendentes.
6. Clique em **Gerar lista de compra** para enviar o estoque consultado à aba operacional **Lista de compra**.
7. Para vendas do dia, clique em **Usar estoque atual para o dia** e informe somente os itens vendidos.
8. Clique em **Encerrar vendas do dia** para atualizar o estoque, recalcular os valores e registrar o novo snapshot.
9. Use **Finalizar fechamento** para guardar uma fotografia mensal do estoque e do caixa.
10. Use **Baixar backup** regularmente para manter uma cópia fora do navegador.

## Login Google e sincronização Supabase

O app continua funcionando localmente, mas pode sincronizar o snapshot completo por usuário no Supabase.

1. Crie um projeto no [Supabase](https://supabase.com/) e execute o arquivo [supabase-schema.sql](supabase-schema.sql) no SQL Editor.
2. No Supabase, habilite o provedor **Google** em **Authentication > Providers**.
3. No Google Cloud Console, crie um OAuth Client ID do tipo **Web application** e use a callback URL exibida pelo Supabase em **Authentication > URL Configuration**.
4. No Supabase, adicione a URL publicada do GitHub Pages em **Authentication > URL Configuration > Redirect URLs**, por exemplo `https://seu-usuario.github.io/seu-repositorio/`.
5. Em `index.html`, preencha `SUPABASE_URL` e `SUPABASE_ANON_KEY` com os valores públicos do projeto, em **Project Settings > API**. Nunca use a `service_role key` no navegador.
6. Publique o arquivo atualizado no GitHub Pages e teste **Entrar com Google**.

O primeiro login envia o estado local existente para o Supabase. Nos logins seguintes, o estado salvo na nuvem é carregado e as alterações passam a ser sincronizadas automaticamente. A política RLS garante que cada usuário só leia e altere o próprio registro.

## Checklist de fechamento

A aba **Checklist** permite anexar os documentos do fechamento e informar os totais impressos para conferência:

- Demonstrativo Mensal do Fundo Bíblico;
- Fechamento Fundo Bíblico;
- Saldo do Fundo Bíblico;
- Inventário de Produtos;
- Posição do Estoque;
- Termo de Verificação do Saldo do Caixa;
- DTs, obrigatórias somente quando houver aquisição no período.

Para habilitar o armazenamento dos anexos, execute também no SQL Editor o trecho de Storage presente em [supabase-schema.sql](supabase-schema.sql). Os arquivos são guardados em bucket privado, dentro da pasta do usuário autenticado.

O botão de finalização bloqueia divergências de quantidade, valores, caixa, estoque, Fundo Bíblico, documentos ausentes e DTs necessárias. Campos de atenção, como saldo contábil não informado ou data inválida no Termo, permanecem visíveis para revisão.

## Regras de cálculo

- Compra = `Quantidade mínima - Saldo atual`, limitado a zero.
- Baixa pendente = `Saldo Siga - Físico contado`, limitado a zero.
- Saldo projetado = quantidade física contada quando disponível; caso contrário, saldo do Siga.
- Saldo após vendas = `Saldo inicial - Vendas do dia`, limitado a zero.
- Valor do estoque = `Quantidade em estoque x Valor unitário`.
- Dinheiro físico após vendas = `Dinheiro físico anterior + Valor vendido`.
- O valor do estoque no Siga e o dinheiro contabilizado no Siga permanecem nos valores do último fechamento até que um novo fechamento seja realizado.
- O cruzamento de itens usa o código da planilha na coluna `Item` e o código do Siga em `detail.CodigoAuxiliar`.

## Salvamento e backups

Sem login, as alterações são salvas automaticamente no `localStorage` do navegador após uma breve pausa na edição. Com login Google configurado, o mesmo snapshot também é salvo no Supabase. O estado restaurado inclui produtos, quantidades, comparações, fechamentos, históricos, vendas diárias e configurações da tela.

O salvamento é específico para o navegador e para o perfil utilizado. Limpar os dados do site ou trocar de navegador pode remover o estado local; por isso, use **Baixar backup** para gerar uma cópia JSON.

## Histórico de versões

### v0.5.0 - Vendas diárias e atualização do estoque

- Adicionado fluxo para usar o estoque atual como base do dia.
- Permite lançar somente os itens vendidos.
- Encerramento do dia atualiza quantidades e valores do estoque.
- Criado snapshot histórico após as vendas, mantendo o fechamento original.

### v0.4.0 - Lista de compra baseada no estoque

- Adicionada a lista de compra calculada a partir do saldo projetado.
- Criado o botão **Gerar lista de compra** para enviar os dados à aba operacional.
- Mantida a separação entre consulta histórica e levantamento editável.

### v0.3.0 - Estoque atual e histórico de fechamentos

- Criada a aba **Estoque atual**.
- Adicionados valores do estoque no Siga, valores físicos e valores de caixa.
- Fechamentos passaram a manter snapshots independentes.
- Incluída migração automática de fechamentos antigos para o histórico de estoque.

### v0.2.0 - Salvamento automático

- Adicionado salvamento automático após alterações.
- Estado restaurado automaticamente ao recarregar a página.
- Criado indicador visual do último salvamento.
- Mantidos os comandos de salvar e restaurar manualmente.

### v0.1.0 - MVP inicial

- Importação de planilha.
- Levantamento físico.
- Lista de compra.
- Comparação com Siga.
- Relatórios XLSX e CSV.
- Fechamento mensal e backup JSON.

## Tecnologia e observações

- HTML, CSS e JavaScript em arquivo único.
- SheetJS carregado via CDN para leitura e geração de planilhas.
- Para funcionar totalmente offline, será necessário empacotar a biblioteca SheetJS junto ao projeto.
