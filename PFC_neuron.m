classdef PFC_neuron < handle
%Class for PFC neurons. PFC neurons directly interact with PMC neurons but
%they also indirectly interact with the PMC through the Basal Ganglia
    properties
        activity %current activity of neuron
        t_constant %time constant for neuron
        dt %delta t
    end
    
    methods
        %constructor
        function obj = PFC_neuron(activity, t_constant, dt)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
        end
        
        %updates activity level based on synaptic input to cell
        function obj = update_activity(obj, input)
            if input <= 0
                obj.activity = obj.activity - (obj.activity / ...
                    obj.t_constant)*(obj.dt);
            else
                obj.activity = obj.activity + (tanh(input)-...
                    obj.activity)*(1/obj.t_constant)*(obj.dt); 
            end
        end
    end
end
