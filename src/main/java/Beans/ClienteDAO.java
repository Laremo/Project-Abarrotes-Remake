/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Hibernate.HibernateUtil;
import Mapeos.Cliente;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;


public class ClienteDAO {
    private Session sesion;
    private Transaction tx;
   

    public int guardarCliente(Cliente cliente) throws HibernateException {
        int id = -1;
        try {
            iniciaOperacion();
            id = (Integer) sesion.save(cliente);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            if (sesion != null) sesion.close();
        }
        return id;
    }

    public void eliminaCliente(int ID_Cliente) {
        try {
            iniciaOperacion();
            Cliente cliente = (Cliente) sesion.get(Cliente.class, ID_Cliente);
            sesion.delete(cliente);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
        } finally {
            if (sesion != null) sesion.close();
        }
    }

    public Cliente obtenCliente(int ID_Cliente) throws HibernateException {
        Cliente cliente = null;
        try {
            iniciaOperacion();
            cliente = (Cliente) sesion.get(Cliente.class, ID_Cliente);
        } finally {
            if (sesion != null) sesion.close();
        }
        return cliente;
    }

    public List<Cliente> obtenListaCliente() throws HibernateException {
        List<Cliente> listaClientes = null;
        try {
            iniciaOperacion();
            listaClientes = sesion.createQuery("from Cliente").list();
        } finally {
            if (sesion != null) sesion.close();
        }
        return listaClientes;
    }

    public int actualizaCliente(Cliente cliente) throws HibernateException {
        try {
            iniciaOperacion();
            sesion.update(cliente);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            if (sesion != null) sesion.close();
        }
        return 0;
    }

    private void iniciaOperacion() throws HibernateException {
        sesion = HibernateUtil.getSessionFactory().openSession();
        if(sesion == null){
             throw new HibernateException("Ocurrió un error en la capa de acceso a datos");
        }
        tx = sesion.beginTransaction();
    }

    private void manejaExcepcion(HibernateException he) throws HibernateException {
        if (tx != null) tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he);
    }
}
