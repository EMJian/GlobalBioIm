classdef CostComplexRing < CostIndicator
    % CostComplexRing: Implements
    % the indicator function operator on the complex ring
    % $$ C(x) = \\left\\lbrace \\begin{array}[l]
    % \\text{0~if } \\mathrm{inner}  \\leq \\vert x-y\\vert \\leq \\mathrm{outer}  \\newline
    % + \\infty \\text{ otherwise.} \\end{array} \\right. $$
    % 
    % :param inner: inner radius of the ring (default 0)
    % :param outer: outer radius of the ring (default 1)
    %
    % All attributes of parent class :class:`CostIndicator` are inherited 
    %
    % **Example** CostComplexRing(inner, outer, sz,y)
    %
    % See also :class:`Map`, :class:`Cost`, :class:`CostIndicator`
    
    %%    Copyright (C) 2015
    %     F. Soulez ferreol.soulez@epfl.ch
    %
    %     This program is free software: you can redistribute it and/or modify
    %     it under the terms of the GNU General Public License as published by
    %     the Free Software Foundation, either version 3 of the License, or
    %     (at your option) any later version.
    %
    %     This program is distributed in the hope that it will be useful,
    %     but WITHOUT ANY WARRANTY; without even the implied warranty of
    %     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %     GNU General Public License for more details.
    %
    %     You should have received a copy of the GNU General Public License
    %     along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    %% Properties
    % - Public
    properties (SetObservable, AbortSet)
        inner=0;
        outer = 1;
    end
    
    %% Constructor
    methods
        function this = CostComplexRing(sz,inner, outer,y)
            % Default values
            if nargin<4, y=0; end
            if nargin<2, inner=0; end
            if nargin==0, outer =1; end
            % Call superclass constructor
            this@CostIndicator(sz,y);
            % Set properties
            this.name='CostComplexRing';
            this.isConvex= false;   
            this.inner=inner;
            this.outer = outer;
            % Initialize
            this.initObject('CostComplexRing');         
        end
    end
    %% updateProp method (Private)
    methods (Access = protected)
        function updateProp(this,prop)
            % Reimplemented superclass :class:`CostIndicator`
            
            % Call superclass method
            updateProp@CostIndicator(this,prop);
            % Update current-class specific properties
            if strcmp(prop,'inner') || strcmp(prop,'all')
                if ~isscalar(this.inner)
                    if isnumeric(this.inner)
                        assert(cmpSize(this.sizein,size(this.inner)), 'inner must be equal to this.sz');
                    else
                        error('inner parameter should be numeric');
                    end
                end
            end
            if strcmp(prop,'outer') || strcmp(prop,'all')
                if ~isscalar(this.outer)
                    if isnumeric(this.outer)
                        assert(cmpSize(this.sizein,size(this.outer)), 'outer must be equal to H.sizeout');
                    else
                        error('outer parameter should be numeric');
                    end
                end
            end
        end
    end
    
    %% Core Methods containing implementations (Protected)
    % - apply_(this,x)
    % - applyProx_(this,z,alpha)
    methods (Access = protected)
        function y = applyProx_(this,x,~) % apply the operator
            % Reimplemented from parent class :class:`Cost`. 
                if(isscalar(this.y)&&(this.y==0))
                    y = max(min(this.outer,abs(x)),this.inner) .* exp(1i .* angle(x));
                else
                    res=x-this.y;
                    y = max(min(this.outer,abs(res)),this.inner) .* exp(1i .* angle(res))+this.y;
                end
        end
        function y = apply_(this,x) 
            % Reimplemented from parent class :class:`Cost`.  
            y = 0;           
            if(isscalar(this.y)&&(this.y==0))
                res=abs(x);
            else
                res=abs(x-this.y);
            end
            if(any(res(:)> this.outer(:)))
                y= +inf;
                return;
            end            
            if(any(res(:)< this.inner(:)))
                y= +inf;
                return;
            end
        end      
    end
end
