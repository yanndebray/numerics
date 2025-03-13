function trapezoidalIntegrationApp
    % Create the figure window
    hFig = figure('Name','Numerical Integration App',...
                  'Position',[300 300 600 400]);

    %% Function Selection
    uicontrol('Style','text',...
              'Position',[50,350,100,20],...
              'String','Function:');
    hFuncPopup = uicontrol('Style','popupmenu',...
                           'Position',[150,350,100,20],...
                           'String',{'sin(x)','exp(x)'});

    %% Lower Limit Input
    uicontrol('Style','text',...
              'Position',[50,310,100,20],...
              'String','Lower Limit:');
    hLower = uicontrol('Style','edit',...
                       'Position',[150,310,100,20],...
                       'String','0');

    %% Upper Limit Input
    uicontrol('Style','text',...
              'Position',[50,270,100,20],...
              'String','Upper Limit:');
    hUpper = uicontrol('Style','edit',...
                       'Position',[150,270,100,20],...
                       'String','pi');

    %% Slider for Number of Trapezoids
    uicontrol('Style','text',...
              'Position',[50,230,100,20],...
              'String','Regions:');
    hSlider = uicontrol('Style','slider',...
                        'Position',[150,230,100,20],...
                        'Min',1,'Max',100,...
                        'Value',10,...
                        'SliderStep',[1/99, 10/99]);
    % Display current slider value
    hSliderValue = uicontrol('Style','text',...
                             'Position',[260,230,40,20],...
                             'String','10');
    % Slider callback to update the display text
    hSlider.Callback = @(src,evt) sliderCallback(src, hSliderValue);

    %% Compute Button
    hButton = uicontrol('Style','pushbutton',...
                        'Position',[50,180,100,30],...
                        'String','Compute',...
                        'Callback', @(src,evt) computeCallback(hFuncPopup, hLower, hUpper, hSlider, hSliderValue, hFig));

    %% Axes for Plotting
    % Create axes on the figure for plotting the function and trapezoids
    hAxes = axes('Units','pixels',...
                 'Position',[350,100,220,220]);
    % Store axes handle for use in callback
    guidata(hFig, hAxes);
end

%% Slider Callback Function
function sliderCallback(src, hText)
    % Round the slider value and update the text display
    value = round(src.Value);
    src.Value = value;
    hText.String = num2str(value);
end

%% Compute Callback Function
function computeCallback(hFuncPopup, hLower, hUpper, hSlider, hSliderValue, hFig)
    % Retrieve the function choice
    funcIndex = hFuncPopup.Value;
    functions = { @(x) sin(x), @(x) exp(x) };
    selectedFunc = functions{funcIndex};

    % Read and validate the integration limits
    a = str2double(hLower.String);
    b = str2double(hUpper.String);
    if isnan(a) || isnan(b)
        errordlg('Please enter valid numerical limits.','Input Error');
        return;
    end

    % Get the number of trapezoids from the slider
    n = round(hSlider.Value);
    if n < 1
        n = 1;
    end

    % Compute the x and y values for trapezoidal rule
    x = linspace(a, b, n+1);
    y = selectedFunc(x);
    dx = (b - a)/n;
    % Trapezoidal integration formula
    trapIntegral = dx * (sum(y) - 0.5*(y(1) + y(end)));

    % Display the result in a message box
    msgbox(sprintf('Trapezoidal Integration Result: %.4f', trapIntegral), 'Result');

    % Plot the function and trapezoids
    hAxes = guidata(hFig);  % Retrieve the axes handle
    axes(hAxes);  % Set current axes to hAxes
    cla(hAxes);   % Clear previous plot
    % Plot the function using a fine grid
    xFine = linspace(a, b, 1000);
    plot(xFine, selectedFunc(xFine), 'b-', 'LineWidth',1.5);
    hold on;
    % Draw trapezoidal patches for each region
    for i = 1:n
       % Create a patch representing the trapezoid
       patch([x(i) x(i) x(i+1) x(i+1)], [0 y(i) y(i+1) 0],...
             'r','FaceAlpha',0.3, 'EdgeColor','k');
    end
    hold off;
    title('Trapezoidal Rule Approximation');
    xlabel('x');
    ylabel('f(x)');
end
