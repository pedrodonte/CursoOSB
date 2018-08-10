CREATE OR REPLACE PACKAGE BODY pck_transacciones_hr AS

    -- Procedimiento que permite buscar todos los empleados pertenecientes a un departamento

    PROCEDURE consulta_emple_por_dpto (
        id_departamento       IN VARCHAR2,
        respuesta_glosa       OUT VARCHAR2,
        respuesta_codigo      OUT VARCHAR2,
        nombre_departamento   OUT VARCHAR2,
        cursor_datos          OUT tipo_cursor
    ) AS
        vo_resp_glosa   VARCHAR2(30); -- Declaracion de una variable local, pero no es utilizada.
    BEGIN
    
        --Asignacion del valor con el nombre del departamento segun ID informado en la entrada.
        SELECT
            department_name
        INTO nombre_departamento
        FROM
            departments
        WHERE
            department_id = id_departamento;
    
        --Asignacion del cursor con los registro asociados segun ID informado en la entrada.

        OPEN cursor_datos FOR SELECT
                                 emp.employee_id,
                                 emp.first_name,
                                 emp.last_name,
                                 emp.email,
                                 jo.job_title
                             FROM
                                 employees emp
                                 JOIN jobs jo ON ( jo.job_id = emp.job_id )
                             WHERE
                                 emp.department_id = id_departamento;

        -- Asignacion de variables con la respuesta indicando el exito de la consulta.

        respuesta_glosa := 'CONSULTA EXITOSA';
        respuesta_codigo := '0';
    EXCEPTION
        WHEN no_data_found THEN -- Asignacion de variables con la respuesta indicando que no se encontraron resultados.
            respuesta_glosa := 'DATOS NO ENCONTRADOS';
            respuesta_codigo := '1';
        WHEN OTHERS THEN -- Asignacion de variables con la respuesta indicando que ocurrio un error al procesar la query.
            respuesta_glosa := 'OCURRIO UN ERROR AL EJECUTAR LA SOLICITUD';
            respuesta_codigo := '2';
    END consulta_emple_por_dpto;

    PROCEDURE consulta_departamentos (
        respuesta_glosa    OUT VARCHAR2,
        respuesta_codigo   OUT VARCHAR2,
        cursor_datos       OUT tipo_cursor
    ) AS
        vo_resp_glosa   VARCHAR2(30); -- Declaracion de una variable local, pero no es utilizada.
    BEGIN
    
        --Asignacion del cursor con los registro asociados segun ID informado en la entrada.
        OPEN cursor_datos FOR SELECT
                                  department_name,
                                  department_id,
                                  location_id,
                                  manager_id
                              FROM
                                  departments
                              ORDER BY
                                  department_name;

        -- Asignacion de variables con la respuesta indicando el exito de la consulta.

        respuesta_glosa := 'CONSULTA EXITOSA';
        respuesta_codigo := '0';
    EXCEPTION
        WHEN no_data_found THEN -- Asignacion de variables con la respuesta indicando que no se encontraron resultados.
            respuesta_glosa := 'DATOS NO ENCONTRADOS';
            respuesta_codigo := '1';
        WHEN OTHERS THEN -- Asignacion de variables con la respuesta indicando que ocurrio un error al procesar la query.
            respuesta_glosa := 'OCURRIO UN ERROR AL EJECUTAR LA SOLICITUD';
            respuesta_codigo := '2';
    END consulta_departamentos;

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
    ) AS
    BEGIN
        SELECT
            employees_seq.NEXTVAL
        INTO id_empleado_nuevo
        FROM
            dual;

        INSERT INTO employees (
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            hire_date,
            job_id,
            salary,
            commission_pct,
            manager_id,
            department_id
        ) VALUES (
            id_empleado_nuevo,
            p_first_name,
            p_last_name,
            p_email,
            p_phone_number,
            SYSDATE,
            p_job_id,
            p_salary,
            0,
            p_manager_id,
            p_department_id
        );

        respuesta_glosa := 'TRANSACCION EXITOSA';
        respuesta_codigo := '1';
    EXCEPTION
        WHEN no_data_found THEN -- Asignacion de variables con la respuesta indicando que no se encontraron resultados.
            respuesta_glosa := 'DATOS NO ENCONTRADOS';
            respuesta_codigo := '1';
        WHEN OTHERS THEN -- Asignacion de variables con la respuesta indicando que ocurrio un error al procesar la query.
            respuesta_glosa := 'Error inesperado: ' || sqlerrm;
            respuesta_codigo := sqlcode;
    END contratar_trabajador;

    PROCEDURE buscar_trabajador (
        p_id_empleado      IN NUMBER,
        respuesta_glosa    OUT VARCHAR2,
        respuesta_codigo   OUT VARCHAR2,
        cursor_datos       OUT tipo_cursor
    ) AS
    BEGIN
        OPEN cursor_datos FOR SELECT
                                  emp.employee_id,
                                  emp.first_name,
                                  emp.last_name,
                                  emp.email,
                                  jo.job_title,
                                  employee_id,
                                  emp.phone_number,
                                  emp.hire_date,
                                  emp.salary,
                                  emp.manager_id,
                                  emp.department_id
                              FROM
                                  employees emp
                                  JOIN jobs jo ON ( jo.job_id = emp.job_id )
                              WHERE
                                  emp.employee_id = p_id_empleado;

        respuesta_glosa := 'TRANSACCION EXITOSA';
        respuesta_codigo := '1';
    END buscar_trabajador;

END pck_transacciones_hr;