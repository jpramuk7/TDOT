/*
These are the commands for registering data layers with Oracle.  
Opening this file in SQL Developer will allow you to run the Oracle commands within that application.

To quickly change the data layer you are registering, double click on the table/layer name and hit CTRL + R.
  This will open the find/replace.  
  
Helpers:
Table Name: TDEC_MNG_AREA
-- SPECIAL NOTE  You will need to change the user schema for any grant commands.
*/

--*****************************************************************************************************************************
--ESRI/ArcGIS STUFF HERE!!!
--If the new layer is loaded through Esri tools, you will need to use this workflow
--  Import or copy/paste the layer into the database through Catalog or Pro with a temporary name
--  In Oracle, create a table as a copy of the imported table with the proper name
    create table TDEC_MNG_AREA as select * from TDEC_MNG_AREA_TEMP;
    commit;

--Change Shape field to Geometry
    alter table TDEC_MNG_AREA rename column SHAPE to GEOMETRY;
    COMMIT;
--*****************************************************************************************************************************

--Revoke SELECT if necessary
--Will need to change User Schema when necessary
    revoke SELECT on "SPATIAL"."TDEC_MNG_AREA" from "SPATIAL_READ" ;

--Find Spatial Index
    select index_name from user_sdo_index_info where table_name = 'TDEC_MNG_AREA';
    SELECT table_name, index_name, owner FROM all_indexes WHERE table_name like 'TDEC_MNG_AREA';
    SELECT table_name, index_name, owner FROM all_indexes WHERE index_name = 'S45_IDX$';
--Drop Spatial Index
--New
    DROP INDEX SPX_TDEC_MNG_AREA;
--Old
    DROP INDEX TDEC_MNG_AREA_SPX;
--Imported through ArcGIS
    DROP INDEX A593_IX1;
    COMMIT;

--Find out what the SRID is
    select a.geometry.sdo_srid, count(objectid) from TDEC_MNG_AREA a group by a.geometry.sdo_srid;
--Count of Geometry Type
    select a.geometry.sdo_gtype, count(objectid) from TDEC_MNG_AREA a group by a.geometry.sdo_gtype;

--Find Oracle SDO Metadata
--selects oracle metadata from current schema
    select * from user_sdo_geom_metadata where table_name = 'TDEC_MNG_AREA';
--selects oracle metadata from all schemas
    select * from all_sdo_geom_metadata where table_name = 'TDEC_MNG_AREA';
--Delete Oracle SDO Metadata
    delete from user_sdo_geom_metadata where table_name = 'TDEC_MNG_AREA';
    COMMIT;

--Insert Oracle SDO Metadata
--SP83 (SRID 2274)    
--2D (GTYPE should be 2001-2007)
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',
        MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-982229.1675648730, 6063320.85868185,0.000005),MDSYS.SDO_DIM_ELEMENT('Y',-3095340.57927969, 3950209.44696703,0.000005)),2274);
        commit;

    --3D Measured (GTYPE should be 3301, 3302, or 3306)
           INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',
        MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-982229.1675648730, 6063320.85868185,0.000005),MDSYS.SDO_DIM_ELEMENT('Y',-3095340.57927969, 3950209.44696703,0.000005),
        MDSYS.SDO_DIM_ELEMENT('M',0, 1000, 0.000005)),2274);
        commit;

-3D Elevation (GTYPE should be 3001-3007)
              INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID)VALUES('TDEC_MNG_AREA','GEOMETRY',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-982229.1675648730, 6063320.85868185,0.000005),
        MDSYS.SDO_DIM_ELEMENT('Y',-3095340.57927969, 3950209.44696703,0.000005),MDSYS.SDO_DIM_ELEMENT('Z',0, 10000, 0.000005)),2274);
        commit;

    --4D Elevation and Measured
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',
        MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-982229.1675648730, 6063320.85868185,0.000005),MDSYS.SDO_DIM_ELEMENT('Y',-3095340.57927969, 3950209.44696703,0.000005),
        MDSYS.SDO_DIM_ELEMENT('M',0, 1000, 0.000005),MDSYS.SDO_DIM_ELEMENT('Z',0, 10000, 0.000005)),2274);
        commit;
    
    --WGS84 (SRID 4326)
    --New - Changed the element identifiers from LON, LAT to X, Y to be consistent in the ability to query out coordinates
   --2D (GTYPE should be 2001-2007)
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-180, 180,0.05),
        MDSYS.SDO_DIM_ELEMENT('Y',-90, 90,0.05)),4326);
        commit;

    --3D Elevation  (GTYPE should be 3001-3007)
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X',-180, 180,0.05),
        MDSYS.SDO_DIM_ELEMENT('Y',-90, 90,0.05),MDSYS.SDO_DIM_ELEMENT('Z',0, 10000, 0.05)),4326);
        commit;

    --Old
    --2D
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('LON',-180, 180,0.05),
        MDSYS.SDO_DIM_ELEMENT('LAT',-90, 90,0.05)),4326);
        commit;
    --3D Elevation
        INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) VALUES('TDEC_MNG_AREA','GEOMETRY',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('LON',-180, 180,0.05),
        MDSYS.SDO_DIM_ELEMENT('LAT',-90, 90,0.05),MDSYS.SDO_DIM_ELEMENT('Z',0, 10000, 0.05)),4326);
        commit;

--Create Spatial Index
    --SPECIAL NOTE: if you have done a find/replace using the word Spatial, you will need to correct the mdsys.spatial_index reference to the commands below.
    --SP83 (SRID 2274)
        create index SPX_TDEC_MNG_AREA on TDEC_MNG_AREA(GEOMETRY) indextype is mdsys.spatial_index PARAMETERS('SDO_FANOUT=50 SDO_INDX_DIMS=2 TABLESPACE=INDX');
    --ask about 
    --layer_gtype default is collection, use this for points
    --work_tablespace - need to create, should be big enough to hold all concurrent indexes being created
        COMMIT;
    
    --WGS84 (SRID 4326)
        create index SPX_TDEC_MNG_AREA on TDEC_MNG_AREA(GEOMETRY) indextype is mdsys.spatial_index PARAMETERS('TABLESPACE=INDX');
    --add tablespace and work_tablespace reference
        commit;
    
    --Geometry Validation Check
    --Record count of all invalid geometry
    --SP83
        select count(*) from TDEC_MNG_AREA a where sdo_geom.validate_geometry_with_context(a.geometry,0.000005) <> 'TRUE';
    --WGS84
        select count(*) from TDEC_MNG_AREA a where sdo_geom.validate_geometry_with_context(a.geometry,0.05) <> 'TRUE';
    --IDs of invalid geometry with reason
    --SP83
        SELECT /*+ PARALLEL(4) */ * from (select c.objectid, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(c.geometry, 0.000005)result FROM TDEC_MNG_AREA c) where result <> 'TRUE' order by objectid;
    --WGS84
        SELECT * from (select c.objectid, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(c.geometry, 0.05)result FROM TDEC_MNG_AREA c) where result <> 'TRUE' order by objectid;
     
--Grant Select to other Schemas if needed
--Will need to change User Schema when necessary
     grant SELECT on "SPATIAL"."TDEC_MNG_AREA" to "SPATIAL" with grant option;
     grant SELECT on "SPATIAL"."TDEC_MNG_AREA" to "SPATIAL_READ" ;
     grant SELECT on "SPATIAL"."TDEC_MNG_AREA" to "SPATIAL_PUBLISH" ;
   

--*****************************************************************************************************************************
--ESRI/ArcGIS STUFF HERE!!!

--  You will need to register the layer with ArcGIS using ArcCatalog.
--    Connect to the database schema containing the layer, right click the layer and select Manage > Register with Geodatabase
--  Once you confirm the layer is functional, delete the temporary table that was used to import the data using ArcCatalog

--*****************************************************************************************************************************
--GEOMEDIA STUFF HERE!!!
--  Registration in Geomedia may need to be done, as well.  There are still people in LRP that use that application.  
--    You will need to have Geomedia on your machine and run the Database Utilities Tool
--******************************************************************************************************************************

--EXTRA Commands that one may need
--Update SRID if necessary
    --StatePlane (SRID 2274)
        update TDEC_MNG_AREA a set a.geometry.sdo_srid = 2274 where a.geometry is not null;
        COMMIT;
    --WGS84 (SRID 4326)
        update TDEC_MNG_AREA a set a.geometry.sdo_srid = 4326 where a.geometry is not null;
        COMMIT;
    
    --Add SE_ANNO_CAD_DATA field
        alter table TDEC_MNG_AREA add SE_ANNO_CAD_DATA BLOB;
        commit;

