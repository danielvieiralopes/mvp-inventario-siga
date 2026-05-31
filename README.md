# MVP Inventário Físico x Siga

Este é um MVP simples, feito em um único arquivo `index.html`, para rodar no navegador.

## Como usar

1. Abra o arquivo `index.html` no navegador.
2. Clique em **Importar planilha XLSX** e selecione sua planilha atual.
3. Faça ou ajuste a contagem na aba **Levantamento físico**.
4. Vá em **Lista de compra** para ver a reposição.
5. Vá em **Comparar com Siga**, cole o JSON do Siga e clique em comparar.
6. Exporte o relatório em XLSX ou CSV.

## Regras

- Compra = `Qtd mínima - Qtd física`, limitado a zero.
- Baixa no Siga = `Qtd Siga - Qtd física`, limitado a zero.
- O cruzamento é feito pelo código do item:
  - Planilha: coluna `Item`
  - JSON Siga: `detail.CodigoAuxiliar`

## Observação

Este MVP usa a biblioteca SheetJS via CDN. Para funcionar 100% offline, o próximo passo é empacotar essa biblioteca junto com o projeto ou transformar o app em uma aplicação ASP.NET/Angular/Blazor.
