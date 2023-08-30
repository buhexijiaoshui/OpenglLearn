#version 330 core

struct Material{

	sampler2D diffuse; //漫反射
	sampler2D specular; //镜面反射
	float shininess; //反光度
};

struct Light
{
	vec3 position;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

out vec4 FragColor;
in vec3 Normal;
in vec3 FragPos;
in vec2 TexCoords;

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform Material material;
uniform Light light;

void main()
{	
	//环境光
	vec3 ambient = vec3(texture(material.diffuse, TexCoords)) * light.ambient;

	//漫反射
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(lightPos - FragPos);
	float diff = max(dot(norm, lightPos), 0.0f);
	vec3 diffuse = diff * light.diffuse * vec3(texture(material.diffuse, TexCoords));

	//镜面反射
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * light.specular * (vec3(texture(material.specular, TexCoords)));

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result, 1.0f);
}