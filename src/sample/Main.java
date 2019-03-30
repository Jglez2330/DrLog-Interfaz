package sample;

import View.ViewManager;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Group;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import org.jpl7.*;

import java.io.File;


public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        FXMLLoader fxmlLoader = new FXMLLoader();

        GridPane bottons = fxmlLoader.load(getClass().getResourceAsStream("../Resources/sample.fxml"));

        ViewManager.newWindow(bottons, 420,280);
    }


    public static void main(String[] args) {



        launch(args);
    }
}
