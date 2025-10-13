function SetRenderingViewParameters(axis_limits,render_view_point,...
                                    render_view_up, figure_handle)
figure(figure_handle);
%----setup rendering frame view parameters
xlabel('x'); ylabel('y'); zlabel('z');
axis equal;
grid on;
% set dimensions of rendering volume
axis(axis_limits)
% set view point
view(render_view_point);
% set view up vector
camup(render_view_up);

camproj('perspective')
