use northwind;

#1.Retornar os dados sobre os produtos comprados por cada cliente 
#(Id do cliente, nome completo do cliente, id do produto, nome do produto, 
#quantidade comprada, preço pago)
select
		customers.id as id,
		concat(customers.first_name, ' ', customers.last_name) as Cliente,
		products.product_name as produto,
		order_details.quantity as quantidade,
		product_id*unit_price as preco_pago
	from orders
	inner join customers on orders.customer_id = customers.id
    inner join order_details on order_details.order_id = orders.id
    inner join products on order_details.product_id = products.id;

 
#2.Retornar um relatório de vendas contendo id do vendedor, nome completo do vendedor, 
#data da venda, Id do cliente, nome completo do cliente, id do produto,
#nome do produto, quantidade comprada, preço pago
select
		employees.id as id_vendedor,
	   concat(employees.first_name, ' ', employees.last_name) as vendedor,
       customers.id as id_cliente,
       concat(customers.first_name, ' ', customers.last_name) as Cliente,
	   orders.order_date as data_venda,
	   order_details.product_id as id_produto,
       products.product_name as nome_produto,
       purchase_order_details.quantity as quantidade,
       (purchase_order_details.unit_cost*purchase_order_details.quantity) as preco_pago
       from orders
	   inner join customers on orders.customer_id = customers.id
	   inner join employees on  orders.employee_id = employees.id
       inner join order_details on order_details.order_id = orders.id
       inner join products on order_details.product_id = products.id
       inner join purchase_orders on purchase_orders.created_by = employees.id
       inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
       
       order by employees.id, customers.id;

#3.Retornar um relatório de compras (tabela purchase orders) 
#contendo os dados do comprador (employees), 
#do fornecedor (suppliers)
#e do produto comprado (products)

select
	concat(suppliers.last_name, suppliers.first_name) as fornecedor,
    suppliers.home_phone as telefone_casa,
    suppliers.email_address as email_fornecedor,
	concat(employees.last_name, employees.first_name) as comprador,
    employees.email_address as email_comprador,
    purchase_order_details.product_id as id_produto,
	products.product_code as cod_produto,
    products.product_name as nome_produto,
    purchase_order_details.quantity as quantidade
    
	from purchase_orders
    inner join employees on purchase_orders.created_by = employees.id
    inner join suppliers on purchase_orders.supplier_id = suppliers.id
	inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join products on purchase_order_details.product_id = products.id
    
    order by purchase_order_details.product_id;

#4. Retornar todos os dados dos vendedores cujo nome possua "afer" em qualquer posição do primeiro nome ou do sobre nome
select
	employees.first_name,
    employees.last_name
	from employees
    where employees.first_name LIKE '%afer%' or employees.last_name LIKE '%afer%';
    
#5. Retornar todos os dados dos produtos comprados no mês de março
select 
	month(purchase_orders.submitted_date) as mes,
    purchase_order_details.product_id as id_produto,
    products.product_code,
    products.product_name,
    purchase_order_details.quantity as qtde_comprada,
    purchase_order_details.unit_cost as preco_uni,
    purchase_order_details.unit_cost*purchase_order_details.quantity as subtotal
    
	from purchase_orders
    inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join products on purchase_order_details.product_id = products.id

    where month(purchase_orders.submitted_date)=3;

 #6.Alterar o relatório de vendas para retornar os dados das vendas que ocorreram no mês de junho
select
	employees.id as id_vendedor,
	concat(employees.first_name, ' ', employees.last_name) as vendedor,
	customers.id as id_cliente,
	concat(customers.first_name, ' ', customers.last_name) as Cliente,
	order_details.product_id,
    products.product_code,
    products.product_name,
    orders.order_date as data_venda,
	order_details.quantity as qtde_comprada,
    order_details.unit_price as preco_uni,
	product_id*unit_price as preco_pago
    
	from orders
    inner join order_details on order_details.order_id = orders.id
	inner join products on order_details.product_id = products.id
    inner join customers on orders.customer_id = customers.id
	inner join employees on  orders.employee_id = employees.id

	where month(orders.order_date)=6;
    
#7. Retornar a quantidade de cada produto vendido (dados do produto e quantidade)
select 
	order_details.product_id,
    products.product_name,
    sum(order_details.quantity) as qntd_vendas
	from orders
    inner join order_details on order_details.order_id = orders.id
    inner join products on order_details.product_id = products.id
    
    group by order_details.product_id, products.product_name
    order by products.product_name;
    
#8.Retornar a quantidade de cada produtos comprado mês a mês
select 
	month(purchase_orders.submitted_date) as mes,
	purchase_order_details.product_id,
    products.product_name,
    sum(purchase_order_details.quantity) as qntd_compras
	from purchase_orders
    inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join products on purchase_order_details.product_id = products.id
    
    group by purchase_order_details.product_id, products.product_name
    order by purchase_orders.submitted_date;
    
    use northwind;
#9. Retornar quantidade de vendas que cada vendedor realizou
select 
	concat(employees.first_name, ' ', employees.last_name) as vendedor,
	count(order_details.quantity) as quantidade_vendas
	from orders
	inner join order_details on order_details.order_id = orders.id
    inner join employees on orders.employee_id = employees.id
    
    group by employees.first_name
    order by employees.first_name;

#10. Retornar o total (em moeda) que cada cliente comprou da empresa por vendedor
select 
	customers.id as id_cliente,
	concat(customers.first_name, ' ', customers.last_name) as cliente,
    employees.id as id_vendedor,
	concat(employees.first_name, ' ', employees.last_name) as vendedor,
	sum(purchase_order_details.quantity*purchase_order_details.unit_cost) as total_moeda
    
	from purchase_orders
	inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join employees on purchase_orders.created_by = employees.id
    inner join orders on orders.employee_id = employees.id
    inner join customers on orders.customer_id = customers.id
    
    group by customers.id, employees.id
    order by customers.first_name;
    
#11. Retornar o total vendido (em moeda) que cada vendedor vendeu
select
		orders.employee_id as id_vendedor,
        concat(employees.first_name, ' ', employees.last_name) as vendedor,
		sum((order_details.quantity*order_details.unit_price)) as total_vendido
		from order_details
        inner join orders on order_details.order_id = orders.id
        inner join employees on orders.employee_id = employees.id
        
        group by orders.employee_id, employees.first_name;
            
#12. Retornar os custo em compras (purchase orders) mês a mês. 
select
	month(purchase_orders.submitted_date) as mes,
	sum(purchase_order_details.quantity*purchase_order_details.unit_cost) as custo_compra
	from purchase_orders
	inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id

	group by month(purchase_orders.submitted_date)
    order by month(purchase_orders.submitted_date);
    
#13. Demonstre o total e o valor médio comprado mês a mês
select
	month(purchase_orders.submitted_date) as mes,
    concat(suppliers.first_name, ' ', suppliers.last_name) as comprador,
    avg(purchase_order_details.quantity*purchase_order_details.unit_cost) as custo_medio,
	sum(purchase_order_details.quantity*purchase_order_details.unit_cost) as custo_total
    
	from purchase_orders
	inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join suppliers on purchase_orders.supplier_id = suppliers.id

	group by month(purchase_orders.submitted_date)
    order by month(purchase_orders.submitted_date);


#14. Retornar um relatório gerencial de compras com a quantidade comprada, o custo
#médio e o custo total de cada produto comprado mês a mês

select
	month(purchase_orders.submitted_date) as mes,
    purchase_order_details.product_id,
    products.product_name,
	sum(purchase_order_details.quantity) as qntd_comprada,
    avg(purchase_order_details.quantity*purchase_order_details.unit_cost) as custo_medio,
	sum((purchase_order_details.quantity*purchase_order_details.unit_cost)) as custo_total
    
	from purchase_orders
	inner join purchase_order_details on purchase_order_details.purchase_order_id = purchase_orders.id
    inner join products on purchase_order_details.product_id = products.id
    
	group by purchase_order_details.product_id, products.product_name, month(purchase_orders.submitted_date)
    order by purchase_orders.submitted_date;
