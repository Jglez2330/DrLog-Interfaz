package Controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import org.jpl7.*;


public class ConsultaMenu {

    static Boolean inicioConversacion = true;

    @FXML
    private TextArea textoLectura;


    @FXML
    private TextField textoCliente;

    @FXML
    public void onEnter(ActionEvent event) {

        Query q2;
        Variable X = new Variable("X");
        if(inicioConversacion.booleanValue()) {

            Query q1 = new Query(
                    "consult",
                    new Term[]{new Atom("src/Resources/MainLogica.pl")}
            );
            System.out.println(q1.hasSolution());

            q2 = new Query(
                    "consultaMedica",

                    new Term[]{new Atom(textoCliente.getText()), X}

            );

            inicioConversacion = false;



        }else {
            q2 = new Query(
                    "conversacion",

                    new Term[]{new Atom(textoCliente.getText()), X}

            );

        }

        textoLectura.setText(textoLectura.getText() + "\n" + "Cliente: " + textoCliente.getText());
        textoLectura.setText(textoLectura.getText() + "\n" + "Doctor: " + q2.oneSolution().toString());
        textoCliente.clear();




    }
}
