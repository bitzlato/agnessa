class AddCosineFunction < ActiveRecord::Migration[6.1]
  def change
    execute "
    CREATE or REPLACE FUNCTION public.vector_norm(IN vector double precision[]) RETURNS double precision
      LANGUAGE 'plpgsql'
      AS $BODY$
        BEGIN
          RETURN(SELECT SQRT(SUM(pow)) FROM (SELECT POWER(e,2) as pow from unnest(vector) as e) as norm);
        END;
      $BODY$;
    COMMENT ON FUNCTION public.vector_norm(double precision[]) IS 'This function is used to find a norm of vectors.';



    CREATE OR REPLACE FUNCTION public.dot_product(IN vector1 double precision[], IN vector2 double precision[]) RETURNS double precision
      LANGUAGE 'plpgsql'
      AS $BODY$
        BEGIN
          RETURN(SELECT sum(mul) FROM (SELECT v1e*v2e as mul FROM unnest(vector1, vector2) AS t(v1e,v2e)) AS denominator);
        END;
      $BODY$;
    COMMENT ON FUNCTION public.dot_product(double precision[], double precision[]) IS 'This function is used to find a cosine similarity between two multi-dimensional vectors.';



    CREATE OR REPLACE FUNCTION public.cosine_similarity(IN vector1 double precision[], IN vector2 double precision[]) RETURNS double precision
      LANGUAGE 'plpgsql'
      AS $BODY$
        BEGIN
          RETURN ( SELECT ((SELECT public.dot_product(vector1, vector2) as dot_pod)/((SELECT public.vector_norm(vector1) as norm1) * (SELECT public.vector_norm(vector2) as norm2)))  AS similarity_value);
        END;
      $BODY$;
    COMMENT ON FUNCTION public.cosine_similarity(double precision[], double precision[]) IS 'this function is used to find a cosine similarity between two vector';"
  end
end
