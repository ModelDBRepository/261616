classdef STN_neuron < handle
    %This class is for STN neurons. These neurons are inhibited by GPe
    %neurons and then excite the SNr/GPi neurons. They are a part of the
    %INDIRECT pathway
    
    properties
        activity; %activity of the neuron
        t_constant; %time constant
        dt; %delta t
        drstn; %tonic drive to STN
        wgpe; %weight of inhibitory connection between GPe and STN
        whd; %weight of the hyperdirect pathway
        synaptic_input; %total synaptic input to cell
    end
    
    methods
        function obj = STN_neuron(activity,t_constant,dt,drstn,wgpe,whd)
            obj.activity = activity;
            obj.t_constant = t_constant;
            obj.dt = dt;
            obj.drstn = drstn;
            obj.wgpe = wgpe;
            obj.whd = whd;
            %obj.synaptic_input = 0;
        end
        
        function obj = update_si(obj,GPe_neuron,PMC)
            %Calculates total synaptic input to STN neuron
            %   ONLY put in GPe_neuron corresponding to the same action
            obj.synaptic_input = obj.drstn - ...
                (obj.wgpe)*(GPe_neuron.activity)+(obj.whd)*(PMC.activity)+0.*rand;
        end
        
        function obj = update_activity(obj)
            %updates acitivty of STN neuron based on synaptic input
            if obj.synaptic_input <= 0
                obj.activity = obj.activity - ((obj.activity -0.1*rand)/ ...
                    obj.t_constant)*(obj.dt*15.0/12.8);
            else
                obj.activity = obj.activity + (tanh(obj.synaptic_input)...
                    +0.1*rand- obj.activity)*(1/obj.t_constant)*(obj.dt*15.0/12.8);
            end
        end
    end
end

