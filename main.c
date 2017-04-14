#include <windows.h>
#include <gl/gl.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

LRESULT CALLBACK WindowProc(HWND, UINT, WPARAM, LPARAM);
void EnableOpenGL(HWND hwnd, HDC*, HGLRC*);
void DisableOpenGL(HWND, HDC, HGLRC);
//Initial Variables and Parameterss
//Determined by the size and number of particles in the simulation
int dataRows = 3000;
int dataColumns = 12001;
float data[3000][12001];
char str[3000*12001];
int nParticles = 2000;
int plotStep = 1;

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
    WNDCLASSEX wcex;
    HWND hwnd;
    HDC hDC;
    HGLRC hRC;
    MSG msg;
    BOOL bQuit = FALSE;

    //Simulation time
    int frameTime = 1;
    //Rotational varaible for frame of reference
    float theta = 0.10*frameTime;
    //Defining the trails behind particles
    //Larger tL means longer history
    int tailLength = 10;
    //Smaller tD means more particles
    int tailDensity = 1;

    //Adaptive zooming
    float zoom =0.08;

    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style = CS_OWNDC;
    wcex.lpfnWndProc = WindowProc;
    wcex.cbClsExtra = 0;
    wcex.cbWndExtra = 0;
    wcex.hInstance = hInstance;
    wcex.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    wcex.lpszMenuName = NULL;
    wcex.lpszClassName = "GLSample";
    wcex.hIconSm = LoadIcon(NULL, IDI_APPLICATION);;


    if (!RegisterClassEx(&wcex))
        return 0;

    // create main window
    hwnd = CreateWindowEx(0,
                          "GLSample",
                          "PHYS 350",
                          WS_OVERLAPPEDWINDOW,
                          CW_USEDEFAULT,
                          CW_USEDEFAULT,
                          1280,
                          600,
                          NULL,
                          NULL,
                          hInstance,
                          NULL);
    ShowWindow(hwnd, nCmdShow);
    // enable OpenGL for the window
    EnableOpenGL(hwnd, &hDC, &hRC);

    //Load CSV Data
            FILE * fp;
            fp = fopen ("nolanTest11.csv", "r");
            int i;
            int j;
            float temp;

            char temp2;
            fgets(str, dataRows*dataColumns, fp);
            for(i=0;i<dataRows;i++){
                for(j=0;j<dataColumns;j++){
                    if (fscanf(fp, "%f", &temp) == 1) {
                        data[i][j] = temp;
                      // printf(" %f for %i%i", data[i][j],i,j);
                    }
                   // printf("\n");
                    fscanf(fp, "%[, ]", &temp2);
                }
            }
            fclose(fp);
    while (!bQuit)
    {
        //Main program run loop
        // check for messages
        if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            // handle or dispatch messages
            if (msg.message == WM_QUIT)
            {
                bQuit = TRUE;
            }
            else
            {
                TranslateMessage(&msg);
                DispatchMessage(&msg);
            }
        }
        else
        {

            // OpenGL animation code
            glPushMatrix();
            glMatrixMode(GL_MODELVIEW);
            glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
            glClear(GL_COLOR_BUFFER_BIT);
            //1 Unit from orign
            glTranslatef(0.0, 0.0, 0.0);
            // Tilt system 15 degrees downward in order to view
            // from above the xy-plane.
            glRotatef(15.0, 1.0, 0.0, 0.0);
            theta = 0.10*frameTime;
            glRotatef(theta, 0.0, 1.0, 0.0);
            //Disable two lines above and enable
            //line below for static frame
            //glRotatef(5.0, 0.0, 1.0, 0.0);
            glRotatef(0.0, 0.0, 0.0, 1.0);


            glPointSize(4); // Points are n pixels in diameter
            glEnable(GL_POINT_SMOOTH);
            glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            //Draw Interparticle bonds

            glColor3f(0, 0, 1);
            float xi, yi, zi, xj, yj, zj, x_cam, y_cam, z_cam, dist_ij, dist_camera;
/**            for(i = 1;i <= (dataColumns-1)/2;i = i+3){
                xi = data[frameTime+tailLength+1][i];
                yi = data[frameTime+tailLength+1][i+1];
                zi = data[frameTime+tailLength+1][i+2];
                    for(j = 1;j <= (dataColumns-1)/2;j = j + 3){
                        xj = data[frameTime+tailLength+1][j];
                        yj = data[frameTime+tailLength+1][j+1];
                        zj = data[frameTime+tailLength+1][j+2];
                        dist_ij = sqrt(pow(xi-xj,2.0) + pow(yi-yj,2.0) + pow(zi-zj,2.0));
                        if(dist_ij < 1.1){
                            glColor3f(0, (pow(dist_ij,10.0)/pow(1.1,10.0)), (pow(dist_ij,10.0)/pow(1.1,10.0)));
                            glLineWidth(2.0);
                            glBegin(GL_LINES);
                                glVertex3f(zoom*data[frameTime+tailLength+1][i],zoom*data[frameTime+tailLength+1][i+1],zoom*data[frameTime+tailLength+1][i+2]);
                                glVertex3f(zoom*data[frameTime+tailLength+1][j],zoom*data[frameTime+tailLength+1][j+1],zoom*data[frameTime+tailLength+1][j+2]);
                            glEnd();
                        }
                    }
                }
**/

            //Draw Coordinate Axis
            glColor3f(1.0, 1.0, 1.0);
        //X-axis
            glBegin(GL_LINES);
                glVertex3f(-1, 0, 0);
                glVertex3f(1, 0, 0);
            glEnd();
            //Y-axis
            glBegin(GL_LINES);
                glVertex3f(0, 1, 0);
                glVertex3f(0, -1, 0);
            glEnd();
            //Z-axis
            glBegin(GL_LINES);
                glVertex3f(0, 0, -1);
                glVertex3f(0, 0, 1);
            glEnd();


            int i;
            int j;


            for(j = frameTime;j <= (frameTime + tailLength);j = j + tailDensity){
                glPointSize(2 - j/(frameTime+tailLength));
                glBegin(GL_POINTS);
                for(i = 1;i <= (dataColumns-1)/2;i = i+3){
                    if(i <= (dataColumns-1)/4){
                        glColor3f(1, 0, 1);
                    }else{
                        glColor3f(1, 0, 0);
                    }
                    glVertex3f(zoom*data[j][i],zoom*data[j][i+1],zoom*data[j][i+2]);
                }
                glEnd();
            }

            float pointSize = 1.0;
            for(i = 1;i <= (dataColumns-1)/2;i = i+3){
                x_cam = zoom*data[frameTime+tailLength+1][i];
                y_cam = zoom*data[frameTime+tailLength+1][i+1];
                z_cam = zoom*data[frameTime+tailLength+1][i+2]-1;
                dist_camera = sqrt(pow(x_cam,2.0) + pow(y_cam,2.0) + pow(z_cam,2.0));
                // glPointSize(pointSize - dist_camera*2);
                glBegin(GL_POINTS);
                    if(i <= (dataColumns-1)/4){
                        glColor3f(1, 0, 1);
                    }else{
                        glColor3f(1, 0, 0);
                    }
                    glVertex3f(zoom*data[frameTime+tailLength+1][i],zoom*data[frameTime+tailLength+1][i+1],zoom*data[frameTime+tailLength+1][i+2]);

                glEnd();
            }


            glPopMatrix();

            SwapBuffers(hDC);
            //zoom = 0.0001 + 0.15*frameTime/dataRows;
        if(tailLength > 1){
            if(frameTime % 100 == 0){
            tailLength = tailLength - (1);
            }
        }
        //Ends the simulation
        if(frameTime < (dataRows - (plotStep*2 + tailLength))){
            frameTime = frameTime+plotStep;
        }else{
            //Enable to quit instead of pausing at the end of the simulation
            //bQuit = TRUE;
        }
            //Changes the speed of the visualization
            Sleep(1);
        }
    }

    // shutdown OpenGL
    DisableOpenGL(hwnd, hDC, hRC);

    // destroy the window explicitly
    DestroyWindow(hwnd);

    return msg.wParam;
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
        case WM_CLOSE:
            PostQuitMessage(0);
        break;

        case WM_DESTROY:
            return 0;

        case WM_KEYDOWN:
        {
            switch (wParam)
            {
                case VK_ESCAPE:
                    PostQuitMessage(0);
                break;
            }
        }
        break;

        default:
            return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }

    return 0;
}

void EnableOpenGL(HWND hwnd, HDC* hDC, HGLRC* hRC)
{
    PIXELFORMATDESCRIPTOR pfd;

    int iFormat;

    // get the device context (DC)
    *hDC = GetDC(hwnd);

    // set the pixel format for the DC
    ZeroMemory(&pfd, sizeof(pfd));

    pfd.nSize = sizeof(pfd);
    pfd.nVersion = 1;
    pfd.dwFlags = PFD_DRAW_TO_WINDOW |
                  PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
    pfd.iPixelType = PFD_TYPE_RGBA;
    pfd.cColorBits = 24;
    pfd.cDepthBits = 16;
    pfd.iLayerType = PFD_MAIN_PLANE;

    iFormat = ChoosePixelFormat(*hDC, &pfd);

    SetPixelFormat(*hDC, iFormat, &pfd);

    // create and enable the render context (RC)
    *hRC = wglCreateContext(*hDC);

    wglMakeCurrent(*hDC, *hRC);
}

void DisableOpenGL (HWND hwnd, HDC hDC, HGLRC hRC)
{
    wglMakeCurrent(NULL, NULL);
    wglDeleteContext(hRC);
    ReleaseDC(hwnd, hDC);
}



