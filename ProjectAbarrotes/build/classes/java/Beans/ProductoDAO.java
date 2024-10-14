/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package java.Beans;

import java.Hibernate.HibernateUtil;
import java.Mapeos.Producto;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author USUARIO
 */
public class ProductoDAO {

      private Session sesion;
    private Transaction tx;

    public int guardaProducto(java.Mapeos.Producto producto) throws HibernateException {
        int id = -1;

        try {
            iniciaOperacion();
            id = (Integer) sesion.save(producto);
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

    public void eliminaProducto(int ProductoNo) {
        try {
            iniciaOperacion();
            Producto producto = (Producto) sesion.get(Producto.class, ProductoNo);
            sesion.delete(producto);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
        } finally {
            sesion.close();
        }
    }

    public Producto obtenProducto(int NoProducto) throws HibernateException {
        Producto producto = null;
        try {
            iniciaOperacion();
            producto = (Producto) sesion.get(Producto.class, NoProducto);
        } finally {
            sesion.close();
        }
        return producto;
    }

    public List<Producto> obtenListaProducto() throws HibernateException {
        List<Producto> listaProductos = null;

        try {
            iniciaOperacion();
            listaProductos = sesion.createQuery("from Producto").list();
        } finally {
            sesion.close();
        }
        return listaProductos;
    }

    public int actualizaProducto(java.Mapeos.Producto producto) throws HibernateException {
        try {
            iniciaOperacion();
            sesion.update(producto);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            sesion.close();
        }
        return 0;
    }

    private void iniciaOperacion(){
       try{
           
       
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
        }catch(Exception e){
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    private void manejaExcepcion(HibernateException he) throws HibernateException {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he);
    }
    
    
    
}
