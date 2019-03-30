package Controller;

import View.ViewManager;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.GridPane;

import java.io.IOException;

public class ControllerMenu {
    @FXML
    public void comenzarConsulta(ActionEvent event) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader();
        GridPane pane = fxmlLoader.load(getClass().getResourceAsStream("../Resources/Consultorio.fxml"));
        ViewManager.newWindow(pane,600,428);

    }

    @FXML
    public void expandirBaseConsulta(ActionEvent event) throws IOException {

        FXMLLoader fxmlLoader = new FXMLLoader();
        GridPane pane = fxmlLoader.load(getClass().getResourceAsStream("../Resources/ActualizarBaseDatos.fxml"));
        ViewManager.newWindow(pane,600,427);


    }


}
