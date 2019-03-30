package Controller;

public class Enfermedad {
    private String nombre;

    private String sintoma1;
    private String sintoma2;
    private String sintoma3;

    private String causas;

    private String tratamientos;

    private String areaSintoma1;
    private String areaSintoma2;
    private String areaSintoma3;

    private String prevecionSintoma1;
    private String prevecionSintoma2;
    private String prevecionSintoma3;

    private String tratamientosPrevios;

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getSintoma1() {
        return sintoma1;
    }

    public void setSintoma1(String sintoma1) {
        this.sintoma1 = sintoma1;
    }

    public String getSintoma2() {
        return sintoma2;
    }

    public void setSintoma2(String sintoma2) {
        this.sintoma2 = sintoma2;
    }

    public String getSintoma3() {
        return sintoma3;
    }

    public void setSintoma3(String sintoma3) {
        this.sintoma3 = sintoma3;
    }

    public String getCausas() {
        return causas;
    }

    public void setCausas(String causas) {
        this.causas = causas;
    }

    public String getTratamientos() {
        return tratamientos;
    }

    public void setTratamientos(String tratamientos) {
        this.tratamientos = tratamientos;
    }


    public String getAreaSintoma1() {
        return areaSintoma1;
    }

    public void setAreaSintoma1(String areaSintoma1) {
        this.areaSintoma1 = areaSintoma1;
    }

    public String getAreaSintoma2() {
        return areaSintoma2;
    }

    public void setAreaSintoma2(String areaSintoma2) {
        this.areaSintoma2 = areaSintoma2;
    }

    public String getAreaSintoma3() {
        return areaSintoma3;
    }

    public void setAreaSintoma3(String areaSintoma3) {
        this.areaSintoma3 = areaSintoma3;
    }

    public String getPrevecionSintoma1() {
        return prevecionSintoma1;
    }

    public void setPrevecionSintoma1(String prevecionSintoma1) {
        this.prevecionSintoma1 = prevecionSintoma1;
    }

    public String getPrevecionSintoma2() {
        return prevecionSintoma2;
    }

    public void setPrevecionSintoma2(String prevecionSintoma2) {
        this.prevecionSintoma2 = prevecionSintoma2;
    }

    public String getPrevecionSintoma3() {
        return prevecionSintoma3;
    }

    public void setPrevecionSintoma3(String prevecionSintoma3) {
        this.prevecionSintoma3 = prevecionSintoma3;
    }

    public String getTratamientosPrevios() {
        return tratamientosPrevios;
    }

    public void setTratamientosPrevios(String tratamientosPrevios) {
        this.tratamientosPrevios = tratamientosPrevios;
    }

    public String nombres() {

        String enfermedad = String.format("enfermedad(\"%s\").\n", this.nombre).toLowerCase();

        return enfermedad;

    }

    public String sintomas() {
        String sintoma1 = String.format("sintoma(%s).\n", this.sintoma1).toLowerCase();
        String sintoma2 = String.format("sintoma(%s).\n", this.sintoma2).toLowerCase();
        String sintoma3 = String.format("sintoma(%s).\n", this.sintoma3).toLowerCase();

        return String.format(" %s %s %s",sintoma1,sintoma2,sintoma3 );
    }

    public String causasDB() {
        String causa = String.format("causa(\"%s\",\"%s\").\n", this.causas,this.nombre).toLowerCase();

        return causa;
    }

    public String tratamientosDB() {

        String tratamientos = String.format("tratamiento_enfermedad(\"%s\",\"%s\").\n",this.tratamientos,this.nombre).toLowerCase();

        return tratamientos;
    }

    public String area() {

        String areaSintoma1 = String.format("sintoma_area(%s, %s).\n",this.sintoma1,this.areaSintoma1).toLowerCase();
        String areaSintoma2 = String.format("sintoma_area(%s, %s).\n",this.sintoma2,this.areaSintoma2).toLowerCase();
        String areaSintoma3 = String.format("sintoma_area(%s, %s).\n",this.sintoma3,this.areaSintoma3).toLowerCase();

        return String.format("%s %s %s", areaSintoma1,areaSintoma2,areaSintoma3);
    }

    public String prevencion() {
        String prevencionSintoma1 = String.format("prevencion(\"%s\").\n",this.prevecionSintoma1).toLowerCase();
        String prevencionSintoma2 = String.format("prevencion(\"%s\").\n",this.prevecionSintoma2).toLowerCase();
        String prevencionSintoma3 = String.format("prevencion(\"%s\").\n",this.prevecionSintoma3).toLowerCase();

        return String.format(prevencionSintoma1,prevencionSintoma2,prevencionSintoma3);
    }

    public String tratamientoPrevio() {

        String tratamientoPrevio = String.format("tratamiento_previo(\"%s\",\"%s\").\n",this.nombre,this.tratamientosPrevios).toLowerCase();

        return tratamientoPrevio;
    }

    public String areaPrevencion() {

        String prevencioArea1 = String.format("prevencion_area(\"%s\",%s).\n",this.prevecionSintoma1,this.sintoma1).toLowerCase();
        String prevencioArea2 = String.format("prevencion_area(\"%s\",%s).\n",this.prevecionSintoma2,this.sintoma2).toLowerCase();
        String prevencioArea3 = String.format("prevencion_area(\"%s\",%s).\n",this.prevecionSintoma3,this.sintoma3).toLowerCase();

        return String.format("%s %s %s", prevencioArea1,prevencioArea2,prevencioArea3);
    }

    public String areaEnfermedad() {
        String enfermedadArea1 = String.format("enfermedad_area(\"%s\",%s).\n",this.nombre,this.areaSintoma1).toLowerCase();
        String enfermedadArea2 = String.format("enfermedad_area(\"%s\",%s).\n",this.nombre,this.areaSintoma2).toLowerCase();
        String enfermedadArea3 = String.format("enfermedad_area(\"%s\",%s).\n",this.nombre,this.areaSintoma3).toLowerCase();


        return String.format("%s %s %s", enfermedadArea1,enfermedadArea2,enfermedadArea3);
    }
}
