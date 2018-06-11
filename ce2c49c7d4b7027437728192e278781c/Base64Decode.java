package org.apache.drill.contrib.function;

import com.google.common.base.Strings;
import com.google.common.io.BaseEncoding;
import io.netty.buffer.DrillBuf;
import org.apache.drill.exec.expr.DrillSimpleFunc;
import org.apache.drill.exec.expr.annotations.FunctionTemplate;
import org.apache.drill.exec.expr.annotations.Output;
import org.apache.drill.exec.expr.annotations.Param;
import org.apache.drill.exec.expr.holders.BigIntHolder;
import org.apache.drill.exec.expr.holders.NullableVarCharHolder;
import org.apache.drill.exec.expr.holders.VarCharHolder;
import org.apache.drill.exec.expr.holders.VarBinaryHolder;

import javax.inject.Inject;

@FunctionTemplate(
  names = { "base64_decode"},
  scope = FunctionTemplate.FunctionScope.SIMPLE,
  nulls = FunctionTemplate.NullHandling.NULL_IF_NULL
)
public class Base64Decode implements DrillSimpleFunc {

  @Param NullableVarCharHolder input;

  @Output VarCharHolder out;

  @Inject DrillBuf buffer;

  public void setup() {}

  public void eval() {

    String b64_string = org.apache.drill.exec.expr.fn.impl.StringFunctionHelpers.toStringFromUTF8(input.start, input.end, input.buffer);

    byte[] result = null;

    try {
      result = com.google.common.io.BaseEncoding.base64().decode(b64_string);
    } catch(IllegalArgumentException e) {
    }

    int outputSize = result.length;
    buffer = out.buffer = buffer.reallocIfNeeded(outputSize);
    out.buffer = buffer;
    out.start = 0;
    out.end = result.length;
    buffer.setBytes(0, result, 0, outputSize);

  }

}