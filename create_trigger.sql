CREATE OR REPLACE FUNCTION hash_password_insert()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS
$$
BEGIN
    
    new.senha := crypt(NEW.senha, gen_salt('md5'));

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER hash_password_insert_trigger
    BEFORE INSERT ON USUARIO
    FOR EACH ROW
    EXECUTE PROCEDURE hash_password_insert();