
#include "PVRAssets/model/Mesh.h"
#include <iostream>
struct Attribute
{
    pvr::StringHash semantic;
    pvr::DataType dataType;
    uint8_t width;
    uint16_t offset;
    uint16_t dataIndex;
    bool isNormalized;
};
int main()
{
    using pvr::assets::Mesh;
    using namespace pvr;

    std::cout << "Hello data module!" << std::endl;
    Mesh mesh;
    uint32_t offset = 0;
    auto position_attribute = Mesh::VertexAttributeData("POSITION", DataType::Float16, 4, offset, 0);
    auto position_attribute_index = mesh.addVertexAttribute(position_attribute);
#if 0
    offset += dataTypeSize(position_attribute.getVertexLayout().dataType) * position_attribute.getN();
    auto normal_attribute = Mesh::VertexAttributeData("NORMAL", DataType::RGBA, 1, offset, 1);
    auto normal_attribute_index = mesh.addVertexAttribute(normal_attribute);

    offset += dataTypeSize(normal_attribute.getVertexLayout().dataType) * normal_attribute.getN();
#endif
    offset += dataTypeSize(position_attribute.getVertexLayout().dataType) * position_attribute.getN();
    auto uv_attribute = Mesh::VertexAttributeData("UV0", DataType::Float16, 2, offset, 2);
    auto uv_attribute_index = mesh.addVertexAttribute(uv_attribute);

    auto stride = offset + dataTypeSize(uv_attribute.getVertexLayout().dataType) * uv_attribute.getN(); 
    auto position_data_index = mesh.addData(nullptr, stride * 3, stride, position_attribute_index);


    std::cout << "Mesh has " << mesh.getVertexAttributesSize() << " attributes" << std::endl;


    return 0;
}