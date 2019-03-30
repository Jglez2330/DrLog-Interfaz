package View;

import javafx.fxml.FXMLLoader;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.io.IOException;

public class ViewManager {


    static Stage actualStage = null;

    public static void newWindow(GridPane pane, Integer width, Integer height) throws IOException {


        Group root = new Group();
        Scene scene;

        if (actualStage == null) {

            scene = new Scene(root,width,height);
            ViewManager.actualStage = new Stage();




        }else {

            scene = new Scene(root,width,height);

            actualStage.close();

            ViewManager.actualStage = new Stage();






        }

        ImageView imageView = new ImageView("file:src/Resources/doctorInicio.jpg");//"file:/Users/jglez2330/Documents/Java/DrLog-Interfaz/src/dr.png");//"https://www.diabetesqld.org.au/media/561409/doctor_420x280.jpg");
        imageView.setFitHeight(height);
        imageView.setFitWidth(width);

        root.getChildren().addAll(imageView,pane);

        actualStage.setScene(scene);
        actualStage.show();


    }
}
