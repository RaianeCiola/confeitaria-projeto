from sqlalchemy.orm import Session
from models.models import Cliente, Produto, Pedido

class ClienteRepository:
    ## retornar os contatos
    @staticmethod
    def get_all(db: Session) -> list[Cliente]:
        return db.query(Cliente).all() #select * from tb_clintes
    
    @staticmethod
    #
    # Retornar um cliente a partir do Id
    #
    def get_by_id(db: Session, id: int) -> Cliente:
        return db.query(Cliente).filter(Cliente.id == id).first()
    
    #
    # Salvar um cliente na tabela
    #
    @staticmethod
    def salvar(db: Session, cliente: Cliente) -> Cliente:
       if (Cliente.id):
            db.merge(Cliente)
       else:
            db.add(Cliente)
            db.commit()
            db.refresh(cliente)
       return Cliente
    
    #
    # Deletar um cliente na tabela
    #
    @staticmethod
    def deletar(db: Session, cliente_id: int) -> bool:
        cliente = db.query(Cliente).filter(Cliente.id == cliente_id).first()
        if cliente:
            db.delete(cliente)
            db.commit()
            db.refresh(cliente)
            return True
        return False
    
#--------------------- PRODUTO --------------------------
class ProdutoRepository:
     ## retornar os produtos 
    @staticmethod
    def get_all(db: Session) -> list[Produto]:
        return db.query(Produto).all() #select * from tb_clintes

    #
    # Salvar um produtos na tabela
    #
    @staticmethod
    def salvar(db: Session, Produto: Produto) -> Produto:
       if (Produto.id):
            db.merge(Produto)
       else:
            db.add(Produto)
       db.commit()
       db.refresh(Produto)
       return Produto

    #
    # Retornar um produtos a partir do Id
    #
    @staticmethod
    def get_by_id(db: Session, id: int) -> Produto:
        return db.query(Produto).filter(Produto.id == id).first()

    
    #
    # Deletar um produtos na tabela
    #
    @staticmethod
    def deletar(db: Session, produto_id: int) -> bool:
        produto = db.query(Produto).filter(Produto.id == produto_id).first()
        if produto:
            db.delete(produto)
            db.commit()
            return True
        return False


#---------------------------- Pedido --------------------------
class PedidoRepository:
     ## retornar os Pedidos 
    @staticmethod
    def get_all(db: Session) -> list[Pedido]:
        return db.query(Pedido).all() #select * from tb_clintes
    

    #
    # Retornar um Pedidos a partir do Id
    #
    @staticmethod
    def get_by_id(db: Session, id: int) -> Pedido:
        return db.query(Pedido).filter(Pedido.id == id).first()
    
    #
    # Salvar um Pedidos na tabela
    #
    @staticmethod
    def salvar(db: Session, Pedido: Pedido) -> Pedido:
       if (Pedido.id):
            db.merge(Pedido)
       else:
            db.add(Pedido)
            db.commit()
            db.refresh(Pedido)
       return Pedido
    
    #
    # Deletar um produto na tabela
    #
    @staticmethod
    def deletar(db: Session, pedido_id: int) -> bool:
        pedido = db.query(Pedido).filter(Pedido.id == pedido_id).first()
        if pedido:
            db.delete(pedido)
            db.commit()
            return True
        return False
    
   