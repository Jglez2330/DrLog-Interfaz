package Controller;

import View.ViewManager;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;

import javafx.fxml.FXMLLoader;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;


import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;


public class ActulizarBaseDatosMenu extends ViewManager {


    static Enfermedad enfermedad;

    @FXML
    private TextField nombreEnfermedad;

    @FXML
    private TextField sintoma1;
    @FXML
    private TextField sintoma2;
    @FXML
    private TextField sintoma3;

    @FXML
    private TextArea causas;

    @FXML
    private TextArea tratamientos;

    @FXML
    private TextField areaAfectacion1;
    @FXML
    private TextField areaAfectacion2;
    @FXML
    private TextField areaAfectacion3;

    @FXML
    private TextField prevencionSintoma1;
    @FXML
    private TextField prevencionSintoma2;
    @FXML
    private TextField prevencionSintoma3;

    @FXML
    private TextField tratamientoPrevio;



    @FXML
    public void actualizarBaseDatos(ActionEvent event) throws IOException {

        enfermedad.setPrevecionSintoma1(prevencionSintoma1.getText());
        enfermedad.setPrevecionSintoma2(prevencionSintoma2.getText());
        enfermedad.setPrevecionSintoma3(prevencionSintoma3.getText());

        enfermedad.setTratamientosPrevios(tratamientoPrevio.getText());

        guardarBaseDatos(enfermedad.toString());

        FXMLLoader fxmlLoader = new FXMLLoader();
        GridPane bottons = fxmlLoader.load(getClass().getResourceAsStream("../Resources/sample.fxml"));

        ViewManager.newWindow(bottons,420,280);


    }

    @FXML
    public void cargarSiguientePagina(ActionEvent event) throws IOException {


        this.enfermedad = new Enfermedad();


        this.enfermedad.setNombre(nombreEnfermedad.getText());

        this.enfermedad.setSintoma1(sintoma1.getText());
        this.enfermedad.setSintoma2(sintoma2.getText());
        this.enfermedad.setSintoma3(sintoma3.getText());

        this.enfermedad.setCausas(causas.getText());

        this.enfermedad.setTratamientos(tratamientos.getText());

        this.enfermedad.setAreaSintoma1(areaAfectacion1.getText());
        this.enfermedad.setAreaSintoma2(areaAfectacion2.getText());
        this.enfermedad.setAreaSintoma3(areaAfectacion3.getText());

        FXMLLoader fxmlLoader = new FXMLLoader();
        GridPane bottons = fxmlLoader.load(getClass().getResourceAsStream("../Resources/ActualizarAreasAfectacion.fxml"));

        ViewManager.newWindow(bottons,600,427);

    }

    private void guardarBaseDatos(String nuevaInformacion) {

        try (BufferedWriter baseDatosNombres = new BufferedWriter(new FileWriter("src/Resources/DBNom.pl",true));
             BufferedWriter baseDatosSintoma = new BufferedWriter(new FileWriter("src/Resources/DBSint.pl",true));
             BufferedWriter baseDatosCausas = new BufferedWriter(new FileWriter("src/Resources/DBCaus.pl",true));
             BufferedWriter baseDatosTratamientos = new BufferedWriter(new FileWriter("src/Resources/DBTrat.pl",true));
             BufferedWriter baseDatosArea = new BufferedWriter(new FileWriter("src/Resources/DBArea.pl",true));
             BufferedWriter baseDatosPrevencion = new BufferedWriter(new FileWriter("src/Resources/DBPrevencion.pl",true));
             BufferedWriter baseDatosTratamientosPrevios = new BufferedWriter(new FileWriter("src/Resources/DBTratPrev.pl",true));
             BufferedWriter baseDatosAreaPrevencion = new BufferedWriter(new FileWriter("src/Resources/DBAreaPrev.pl",true));
             BufferedWriter baseDatosAreaEnfermedad = new BufferedWriter(new FileWriter("src/Resources/DBAreaEnf.pl",true));
             BufferedWriter baseDatosNombresBNF = new BufferedWriter(new FileWriter("src/Resources/DBNomBNF.pl",true))) {

            baseDatosNombres.write(enfermedad.nombres());
            baseDatosSintoma.write(enfermedad.sintomas());
            baseDatosCausas.write(enfermedad.causasDB());
            baseDatosTratamientos.write(enfermedad.tratamientosDB());
            baseDatosArea.write(enfermedad.area());
            baseDatosPrevencion.write(enfermedad.prevencion());
            baseDatosTratamientosPrevios.write(enfermedad.tratamientoPrevio());
            baseDatosAreaPrevencion.write(enfermedad.areaPrevencion());
            baseDatosAreaEnfermedad.write(enfermedad.areaEnfermedad());

            baseDatosNombresBNF.write(String.format("nombre([%s|A],A).\n",enfermedad.getNombre()));

        } catch (IOException e) {
            e.printStackTrace();
        }


    }



}
