function fonction_error

if (tango_error == -1)
      %- print error stack
      tango_print_error_stack;
      %- can't continue
      return;
end