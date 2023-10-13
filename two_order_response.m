clc
clear all
ksai_min = 0;
ksai_max = 1;
ksai_default = 0.7;
wn = 5;
v = 0; % 该程序的超调量、峰值时间等物理量计算，仅对阶跃函数有效，即：v=1时有效
fig = uifigure('Name', 'Second order system response curve','Position',[500,500,800,500]);        %创建图形GUI界面
% Number_Field = uieditfield(fig, 'Position', [100, 60, 50, 25]);    %建立参数数值标签
% Number_Field.Value = num2str(ksai_default);
% 创建滑动条
s = uislider(fig, 'Position', [180, 80, 200, 3], ...
            'Limits', [ksai_min, ksai_max], 'Value', ksai_default,...
            'MajorTicks', [ksai_min, (ksai_max - ksai_min)/2, ksai_max]);
shuoming = uilabel(fig, 'Position',[500,400,300,50],'Text','以下物理量仅计算了阶跃函数的相关指标','Fontsize',14);
% 创建阻尼度文本框        
ksai_txt = uilabel(fig, 'Position',[500,350,100,50],'Text','阻尼度 = ','Fontsize',14);
ksai_value = uilabel(fig,'Position',[600,350,100,50],'Text',num2str(ksai_default),'Fontsize',14);
% 创建超调量文本框
M_txt = uilabel(fig, 'Position',[500,300,100,50],'Text','超调量 = ','Fontsize',14);
M_value = uilabel(fig,'Position',[600,300,100,50],'Text','','Fontsize',14);
M_update(M_value,ksai_default);
% 创建峰值时间
tp_txt = uilabel(fig, 'Position',[500,250,100,50],'Text','峰值时间 = ','Fontsize',14);
tp_value = uilabel(fig,'Position',[600,250,100,50],'Text','','Fontsize',14);
tp_update(tp_value,ksai_default,wn);
% 创建调整时间(2%)
ts2_txt = uilabel(fig, 'Position',[500,200,150,50],'Text','调整时间（2%） = ','Fontsize',14);
ts2_value = uilabel(fig,'Position',[650,200,150,50],'Text','','Fontsize',14);
ts2_update(ts2_value,ksai_default,wn);
% 创建调整时间(4%)
ts4_txt = uilabel(fig, 'Position',[500,150,150,50],'Text','调整时间（4%） = ','Fontsize',14);
ts4_value = uilabel(fig,'Position',[650,150,150,50],'Text','','Fontsize',14);
ts4_update(ts4_value,ksai_default,wn);

% 设置坐标区
ax = uiaxes(fig, 'Position',[80,100,400,350],'Box','On');
ax.XLim = [0, inf];
ax.YLim = [-0.4, 1];
f0 = two_response(wn,ksai_default,0)/wn;
f1 = two_response(wn,ksai_default,1)/wn;
f2 = two_response(wn,ksai_default,2)/wn;
fplot(ax,[f0,f1,f2]);
legend(ax,{'脉冲响应','跃迁响应','斜坡响应'});
% 调用回调函数
s.ValueChangedFcn = @(source, event) UpdateNumField(source,ksai_value,M_value,tp_value,ts2_value,ts4_value,ax,wn,v);


%回调函数
function UpdateNumField(slider, Number_Field,M_value,tp_value,ts2_value,ts4_value,ax,wn,v)
    Number_Field.Text = num2str(slider.Value);
    f0 = two_response(wn,slider.Value,0)/wn;
    f1 = two_response(wn,slider.Value,1)/wn;
    f2 = two_response(wn,slider.Value,2)/wn;
    fplot(ax,[f0,f1,f2]);
    legend(ax,{'脉冲响应','跃迁响应','斜坡响应'});
    M_update(M_value, slider.Value);
    tp_update(tp_value, slider.Value, wn);
    ts2_update(ts2_value, slider.Value, wn);
    ts4_update(ts4_value, slider.Value, wn);
end
% 二阶响应函数计算
function f = two_response(wn, ksai, v)
    syms s
    F = wn^2 / (s^v * (s^2 + 2 * ksai * wn * s + wn^2));
    f = ilaplace(F); 
end
% 更新超调量函数
function M_update(M_value,ksai)
    M = exp(-pi*ksai/sqrt(1 - ksai^2));
    M_value.Text = num2str(M);
end
% 更新峰值时间函数
function tp_update(tp_value, ksai, wn)
    tp = pi / (wn * sqrt(1 - ksai^2));
    tp_value.Text = num2str(tp);
end
% 更新调整时间（2%）函数
function ts2_update(ts2_value, ksai, wn)
    ts2 = 4 / (ksai * wn);
    ts2_value.Text = num2str(ts2);
end
% 更新调整时间（4%）函数
function ts4_update(ts4_value, ksai, wn)
    ts4 = 3 / (ksai * wn);
    ts4_value.Text = num2str(ts4);
end