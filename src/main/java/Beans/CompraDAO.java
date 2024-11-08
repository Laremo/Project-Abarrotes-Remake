package Beans;

import Hibernate.HibernateUtil;
import Mapeos.Compra;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class CompraDAO {

    private Session sesion;
    private Transaction tx;

    public CompraDAO() {
    }

    public int guardaCompra(Compra compra) throws HibernateException {
        int id = -1;

        try {
            iniciaOperacion();
            id = (Integer) sesion.save(compra);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        } finally {
            sesion.close();
        }
        return id;
    }

    public void eliminaCompra(int compraNo) {
        try {
            iniciaOperacion();
            Compra compra = (Compra) sesion.get(Compra.class, compraNo);
            sesion.delete(compra);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
        } finally {
            sesion.close();
        }
    }

    public Compra obtenCompra(int noCompra) throws HibernateException {
        Compra compra = null;
        try {
            iniciaOperacion();
            compra = (Compra) sesion.get(Compra.class, noCompra);
        } finally {
            sesion.close();
        }
        return compra;
    }

    public List<Compra> obtenListaCompra() throws HibernateException {
        List<Compra> listaCompras = null;
        try {
            iniciaOperacion();  // Inicia la sesión de Hibernate
            listaCompras = sesion.createQuery("from Compra").list();
            tx.commit();  // Confirma la transacción
        } catch (HibernateException he) {
            manejaExcepcion(he);  // Manejo de errores
        } finally {
            if (sesion != null) {
                sesion.close();  // Asegúrate de cerrar la sesión
            }
        }
        return listaCompras;
    }

    public int actualizaCompra(Compra compra) throws HibernateException {
        try {
            iniciaOperacion();
            sesion.update(compra);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            sesion.close();
        }
        return 0;
    }

    private void iniciaOperacion() {
        try {
            sesion = HibernateUtil.getSessionFactory().openSession();
            tx = sesion.beginTransaction();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    private void manejaExcepcion(HibernateException he) throws HibernateException {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he);
    }
}
