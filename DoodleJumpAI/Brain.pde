class Brain {
   
  int iNodes, hNodes, oNodes;
  
  Matrix h_i_weights, h_h_weights, o_h_weights;
  
   Brain(int i, int h, int o) {
       iNodes = i;
       hNodes = h;
       oNodes = o;
       
       h_i_weights = new Matrix(hNodes, iNodes+1);
       h_h_weights = new Matrix(hNodes, hNodes+1);
       o_h_weights = new Matrix(oNodes, hNodes+1);
       
       h_i_weights.randomize();
       h_h_weights.randomize();
       o_h_weights.randomize();
   }
   
   void mutate(float mr) {
       h_i_weights.mutate(mr);
       h_h_weights.mutate(mr);
       o_h_weights.mutate(mr);
   }
   
   float[] output(float[] inputsArr) {
      Matrix inputs = o_h_weights.singleColumnMatrixFromArray(inputsArr);
      
      Matrix ip_bias = inputs.addBias();
      
      Matrix hidden_ip = h_i_weights.dot(ip_bias);
      
      Matrix hidden_op = hidden_ip.activate();
      
      Matrix hidden_op_bias = hidden_op.addBias();
      
      Matrix hidden_ip2 = h_h_weights.dot(hidden_op_bias);
      Matrix hidden_op2 = hidden_ip2.activate();
      Matrix hidden_op_bias2 = hidden_op2.addBias();
      
      Matrix output_ip = o_h_weights.dot(hidden_op_bias2);
      Matrix output = output_ip.activate();
      
      return output.toArray();
      
   }
   
   Brain crossover(Brain partner) {
      Brain child = new Brain(iNodes, hNodes, oNodes);
      child.h_i_weights = h_i_weights.crossover(partner.h_i_weights);
      child.h_h_weights = h_h_weights.crossover(partner.h_h_weights);
      child.o_h_weights = o_h_weights.crossover(partner.o_h_weights);
      return child;
   }
   
   Brain clone() {
      Brain clone = new Brain(iNodes, hNodes, oNodes);
      clone.h_i_weights = h_i_weights;
      clone.h_h_weights = h_h_weights;
      clone.o_h_weights = o_h_weights;
      return clone;
   }
}
