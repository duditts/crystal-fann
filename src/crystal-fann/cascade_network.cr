module Fann
  module Network
    class Cascade
      property :nn

      def initialize(input : Int32, output : Int32)
        @output_size = output
        @input_size = input
        @nn = LibFANN.create_shortcut(2, input, output)
      end

      def mse
        LibFANN.get_mse(@nn)
      end

      def close
        LibFANN.destroy(@nn)
      end

      def train_algorithem(algo : LibFANN::TrainEnum)
        LibFANN.set_training_algorithm(@nn, algo)
      end

      def set_output_layer_activation_func(func : LibFANN::ActivationfuncEnum)
        LibFANN.set_activation_function_output(@nn, func)
      end

      def set_hidden_layer_activation_func(func : LibFANN::ActivationfuncEnum)
        LibFANN.set_activation_function_hidden(@nn, func)
      end

      def randomzie_weights(min : Float32, max : Float32)
        # randomize_weights = fann_randomize_weights(ann : Fann*, min_weight : Type, max_weight : Type)
        LibFANN.randomize_weights(@nn, min, max)
      end

      def train_batch(train_data : Pointer(LibFANN::TrainData), opts = {:max_neurons => 500, :desired_mse => 0.01_f64, :log_each => 10})
        # fun cascadetrain_on_data = fann_cascadetrain_on_data(ann : Fann*, data : TrainData*, max_neurons : LibC::UInt, neurons_between_reports : LibC::UInt, desired_error : LibC::Double)
        LibFANN.cascade_train_on_data(@nn, train_data, opts[:max_neurons], opts[:log_each], opts[:desired_mse])
      end

      def run(input : Array(Float64))
        result = LibFANN.run(@nn, input.to_unsafe)
        Slice.new(result, @output_size).to_a
      end
    end
  end
end
