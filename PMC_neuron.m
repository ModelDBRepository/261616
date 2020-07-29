classdef PMC_neuron < handle 
    %This is the class for PMC neurons, which receive input from the PMC as
    %well as the Basal Ganglia. The PMC then relays signals to the spinal
    %cord to enact a movement/behavior 
    
    properties
        activity; %current activity of the neuron
        t_constant; %time constant of neuron (1 msec)
        dt; %delta t
        drm; %tonic drive to PMC neurons (1.3)
        wMinh; %weight of inhibitory connection between PMC neurons (1.7)
        wPFC1; %weight of connection with PFC neuron 1
        wPFC2; %weight of connection with PFC neuron 2
        wgpi; %weight of inhibitory connection with GPi neurons (1.8)
        synaptic_input; %synaptic input to PMC neuron
        learning_rate; %learning rate of neuron (0.001)
        decay_rate; %decay rate of neuron (0.001)
    end
    
    methods
        %constructor
        function obj = PMC_neuron(activity,t_constant,dt,drm,wMinh,...
                wPFC1,wPFC2,wgpi,lr,dr) 
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.drm = drm;
            obj.wMinh = wMinh;
            obj.wPFC1 = wPFC1;
            obj.wPFC2 = wPFC2;
            obj.wgpi = wgpi; 
            %obj.synaptic_input = 0; 
            obj.learning_rate = lr;
            obj.decay_rate = dr; 
        end
        
        function obj = set_si(obj,PFC,PMC_other,GPi_neuron)
            %Calculates synaptic input to this PMC neuron
            %   Need to pass PFC cell, other PMC neuron, and GPi
            obj.synaptic_input = (obj.drm)+(PFC{1}.activity)*(obj.wPFC1)...
                +(PFC{2}.activity)*(obj.wPFC2)-(PMC_other.activity)...
                *(obj.wMinh)-(obj.wgpi)*(GPi_neuron.activity)+0.*rand;
        end
        
        function obj = update_activity(obj)
            %updates activity of PMC neuron using synaptic input to cell
            if obj.synaptic_input <= 0
                obj.activity = obj.activity - ((obj.activity -0.1*rand) / ...
                    obj.t_constant)*(obj.dt);
            else
                obj.activity = obj.activity + (tanh(obj.synaptic_input) ...
                    +0.1*rand- obj.activity)*(1/obj.t_constant)*(obj.dt);
            end
        end
        
        function obj = update_weights(obj,PFC,pfc1input)
            %update synaptic weights of PFC neurons to PMC neurons
            %need to input entire PFC
            if pfc1input ~= 0
                obj.wPFC1 = obj.wPFC1 + (obj.learning_rate * PFC{1}.activity...
                     *obj.activity - obj.decay_rate * obj.wPFC1);
            else
                obj.wPFC2 = obj.wPFC2 + (obj.learning_rate * PFC{2}.activity...
                    *obj.activity - obj.decay_rate * obj.wPFC2);
            end
        end
    end
end

