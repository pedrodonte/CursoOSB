CREATE OR REPLACE PACKAGE pck_transacciones_hr AS
    
    -- Declaracion del tipo cursor
    TYPE tipo_cursor IS REF CURSOR;
    PROCEDURE consulta_emple_por_dpto (
        id_departamento       IN VARCHAR2,
        respuesta_glosa       OUT VARCHAR2,
        respuesta_codigo      OUT VARCHAR2,
        nombre_departamento   OUT VARCHAR2,
        cursor_datos          OUT tipo_cursor
    );

    PROCEDURE consulta_departamentos (
        respuesta_glosa    OUT VARCHAR2,
        respuesta_codigo   OUT VARCHAR2,
        cursor_datos       OUT tipo_cursor
    );

    PROCEDURE contratar_trabajador (
        p_first_name        IN VARCHAR2,
        p_last_name         IN VARCHAR2,
        p_email             IN VARCHAR2,
        p_phone_number      IN VARCHAR2,
        p_job_id            IN VARCHAR2,
        p_salary            IN NUMBER,
        p_manager_id        IN NUMBER,
        p_department_id     IN VARCHAR2,
        respuesta_glosa     OUT VARCHAR2,
        respuesta_codigo    OUT VARCHAR2,
        id_empleado_nuevo   OUT NUMBER
    );

    PROCEDURE buscar_trabajador (
        p_id_empleado      IN NUMBER,
        respuesta_glosa    OUT VARCHAR2,
        respuesta_codigo   OUT VARCHAR2,
        cursor_datos       OUT tipo_cursor
    );

END pck_transacciones_hr;