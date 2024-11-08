/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Hibernate.HibernateUtil;
import Mapeos.Producto;
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
    private int de = 1;
    public ProductoDAO(){
        de = 2;
    }
    public int guardaProducto(Mapeos.Producto producto) throws HibernateException {
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
            iniciaOperacion();  // Inicia la sesión de Hibernate
            listaProductos = sesion.createQuery("from Producto").list();
            tx.commit();  // Confirma la transacción
        } catch (HibernateException he) {
            manejaExcepcion(he);  // Manejo de errores
        } finally {
            if (sesion != null) {
                sesion.close();  // Asegúrate de cerrar la sesión
            }
        }
        return listaProductos;
    }
    public int actualizaProducto(Mapeos.Producto producto) throws HibernateException {
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
