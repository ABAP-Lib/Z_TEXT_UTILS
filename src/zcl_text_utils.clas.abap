class ZCL_TEXT_UTILS definition
  public
  final
  create public .

    public section.

        class-methods:
            read_text_to_string
                importing
                    IV_TDOBJECT type TDOBJECT
                    IV_TDNAME type TDOBNAME
                    IV_TDID type TDID
                    IV_TDSPRAS type TDSPRAS default sy-langu
                returning
                    value(rv_result) type string.

    protected section.
    private section.

ENDCLASS.



CLASS ZCL_TEXT_UTILS IMPLEMENTATION.

  METHOD read_text_to_string.

    DATA : lt_lines    TYPE TABLE OF  tline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
       id                      = iv_tdid
       language                = iv_tdspras
       name                    = iv_tdname
       object                  = iv_tdobject
*        id                      = 'ST'
*        language                = 'F'
*        name                    = 'ZTEST_FJO_TEXT'
*        object                  = 'TEXT'
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc = 0.

      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_line>).

        AT FIRST.
          rv_result =  <fs_line>-tdline.
          CONTINUE.
        ENDAT.

        IF <fs_line>-tdformat IS INITIAL OR <fs_line>-tdformat = '='.
          rv_result = | { rv_result } { <fs_line>-tdline }|.

        ELSE.
          rv_result = | { rv_result }\n{ <fs_line>-tdline }|.

        ENDIF.

      ENDLOOP.

      CONDENSE rv_result.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
