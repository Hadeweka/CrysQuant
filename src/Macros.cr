module CrysQuant
  class Gate
    macro implement(name, alternative_names = [_])
      {{name}} = Gate.new(GateMatrix::{{name}})
      {% for alternative_name in alternative_names %}
        {{alternative_name}} = {{name}}
      {% end %}
    end
  end
end