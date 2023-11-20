select
    a.codigo_filial,
    d.filial,
    d.cgc_cpf cnpj,
    a.chave_nfe,
    a.nf_numero,
    a.serie_nf,
    b.codigo_fiscal_operacao,
    case
        when a.codigo_filial in ('190410', '190412')
        then f.numero_titulo
        else f.cheque_cartao
    end pedido,
    a.valor_total_itens,
    a.frete,
    a.desconto,
    a.valor_total,
    b.codigo_item,
    b.descricao_item,
    c.grade,
    a.peso_liquido,
    a.volumes,
    c.largura,
    c.altura,
    c.comprimento
from loja_nota_fiscal a
inner join
    loja_nota_fiscal_item b
    on b.codigo_filial = a.codigo_filial
    and b.nf_numero = a.nf_numero
    and a.emissao >= '20231001'
    and a.serie_nf = b.serie_nf
    and b.codigo_fiscal_operacao not in ('1202', '2202', '1411', '2411')
inner join produtos c on b.referencia = c.produto
inner join filiais d on a.codigo_filial = d.cod_filial
left join
    loja_venda_pgto e
    on a.nf_numero = e.numero_fiscal_venda
    and a.codigo_filial = e.codigo_filial
    and a.emissao = e.data
left join
    loja_venda_parcelas f
    on e.lancamento_caixa = f.lancamento_caixa
    and a.codigo_filial = f.codigo_filial
    and f.tipo_pgto not in ('W', 'L')
    and e.terminal = f.terminal
order by d.filial, a.emissao, a.nf_numero
