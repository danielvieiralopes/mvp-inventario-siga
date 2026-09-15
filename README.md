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

As alterações são salvas automaticamente no `localStorage` do navegador após uma breve pausa na edição. O estado restaurado inclui produtos, quantidades, comparações, fechamentos, históricos, vendas diárias e configurações da tela.

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
